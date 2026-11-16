local parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local EditProfileBackground = require(parent.EditProfileBackground)
local getDisplayBackgroundId = EditProfileBackground.BackgroundUtils.getDisplayBackgroundId

local color = Color3.fromRGB(185, 185, 185)
local color2 = Color3.fromRGB(200, 200, 200)

local InsertService = game:GetService("InsertService")

local function EditProfileBackgroundViewport(p)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local v = useSelectedTheme()
	local v2 = useLocalUserId()

	local v3 = useSelector(function(p2)
		if p2.ProfilePlatform and p2.ProfilePlatform.Profiles and v2 then
			local v3 = p2.ProfilePlatform.Profiles.User[tostring(v2)]

			if v3 and v3.components and v3.components.ProfileBackground then
				return v3.components.ProfileBackground.assetId
			end
		end

		return -1
	end)

	React.useEffect(function()
		task.defer(function()
			if not v3 then
				return
			end

			local success, result = pcall(function()
				return InsertService:LoadAsset(getDisplayBackgroundId(v3, v))
			end)

			if success and result then
				if ref2.current then
					for _, child in pairs(ref2.current:GetChildren()) do
						child:Destroy()
					end
				end

				local backgroundModel = Instance.new("Model")
				backgroundModel.Name = "BackgroundModel"
				backgroundModel.Parent = ref2.current

				for _, child in pairs(result:GetChildren()) do
					child.Parent = backgroundModel
				end

				backgroundModel:PivotTo(CFrame.new(0, 7, -4.5))
				result:Destroy()

				local current = ref.current

				if current then
					current.Ambient = color
					current.LightColor = color2
					current.LightDirection = Vector3.new(0, 0.2, 0.2)
				end
			end
		end)
	end, { v3, v })

	React.useEffect(function()
		if ref.current and ref3.current then
			ref.current.CurrentCamera = ref3.current
		end
	end)

	return React.createElement(View, { Size = UDim2.new(1, 0, 0, p.height) }, {
		Background = React.createElement("ViewportFrame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			ref = ref,
			Ambient = color,
			LightColor = color2,
			BackgroundTransparency = 1
		}, {
			WorldModel = React.createElement("WorldModel", { ref = ref2 }),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 7, 4), Vector3.new(0, 7, 10)),
				ref = ref3
			})
		})
	})
end

return EditProfileBackgroundViewport
