local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View
local RoactUtils = require(Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
local getDisplayBackgroundId = require(Parent.EditProfileBackground).BackgroundUtils.getDisplayBackgroundId
local color3 = Color3.fromRGB(185, 185, 185)
local color3_2 = Color3.fromRGB(200, 200, 200)
local InsertService = game:GetService("InsertService")

local function EditProfileBackgroundViewport(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), useSelectedTheme (copy), useLocalUserId (copy), useSelector (copy), InsertService (copy), getDisplayBackgroundId (copy), color3 (copy), color3_2 (copy), View (copy)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(nil)
	local v17 = useSelectedTheme()
	local v18 = useLocalUserId()
	local v19 = useSelector(function(p1) -- line: 44
		-- upvalues: v18 (copy)
		if p1.ProfilePlatform and (p1.ProfilePlatform.Profiles and v18) then
			local v21 = p1.ProfilePlatform.Profiles.User[tostring(v18)]

			if v21 and v21.components and v21.components.ProfileBackground then
				return v21.components.ProfileBackground.assetId
			end
		end

		return -1
	end)

	React.useEffect(function() -- line: 54
		-- upvalues: v19 (copy), InsertService (copy), getDisplayBackgroundId (copy), v17 (copy), v15 (copy), v14 (copy), color3 (copy), color3_2 (copy)
		task.defer(function() -- line: 56
			-- upvalues: v19 (copy), InsertService (copy), getDisplayBackgroundId (copy), v17 (copy), v15 (copy), v14 (copy), color3 (copy), color3_2 (copy)
			if not v19 then
				return
			end

			local ok, result = pcall(function() -- line: 61
				-- upvalues: InsertService (copy), getDisplayBackgroundId (copy), v19 (copy), v17 (copy)
				return InsertService:LoadAsset(getDisplayBackgroundId(v19, v17))
			end)

			if ok and result then
				if v15.current then
					for _, child in pairs(v15.current:GetChildren()) do
						child:Destroy()
					end
				end

				local Model = Instance.new("Model")

				Model.Name = "BackgroundModel"
				Model.Parent = v15.current

				for _, child in pairs(result:GetChildren()) do
					child.Parent = Model
				end

				Model:PivotTo(CFrame.new(0, 7, -4.5))
				result:Destroy()

				local current = v14.current

				if current then
					current.Ambient = color3
					current.LightColor = color3_2
					current.LightDirection = Vector3.new(0, 0.20000000298023224, 0.20000000298023224)
				end
			end
		end)
	end, {
		v19,
		v17
	})
	React.useEffect(function() -- line: 94
		-- upvalues: v14 (copy), v16 (copy)
		if v14.current and v16.current then
			v14.current.CurrentCamera = v16.current
		end
	end)

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, t1.height)
	}, {
		Background = React.createElement("ViewportFrame", {
			ZIndex = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = v14,
			Ambient = color3,
			LightColor = color3_2
		}, {
			WorldModel = React.createElement("WorldModel", {
				ref = v15
			}),
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				CFrame = CFrame.lookAt(Vector3.new(0, 7, 4), (Vector3.new(0, 7, 10))),
				ref = v16
			})
		})
	})
end

return EditProfileBackgroundViewport
