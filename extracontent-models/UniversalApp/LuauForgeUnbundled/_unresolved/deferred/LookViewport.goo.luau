local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local cameraPresetsUtility = Thumbnailing.CameraPresetsUtility
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module = require("@luauforge/deferred/gop")
require("@luauforge/bundled/dMc")

local module2 = require("@luauforge/deferred/goq")

local module3 = require("@luauforge/deferred/gor")

local defineFastInt = game:DefineFastInt("AXLookViewportCameraFOV", 56)
local defineFastString = game:DefineFastString("AXLookViewportFallbackEmoteId", "136596589997464")
local module4 = require("@luauforge/bundled/gos")

local function LookViewport(p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef("")
	local v5, v6 = React.useBinding(CFrame.new())
	local v7 = usePrevious(p2.lookDetails)

	React.useEffect(function()
		if ref3.current then
			ref3.current.CurrentCamera = ref2.current
		end
	end, { ref3, ref2 })

	local v8 = React.useCallback(function(p3)
		if ref.current then
			ref.current:ClearAllChildren()
		end

		if not p3 then
			return
		end

		local guid = HttpService:GenerateGUID(false)
		ref4.current = guid

		local avatarModel = module.createAvatarModel(p3)

		if module2() then
			local v9 = p3.displayProperties and p3.displayProperties.emoteAssetId
			local v10

			if module3() and not v9 then
				v9 = defineFastString
				v10 = true
			else
				v10 = false
			end

			local function fn()
				if v9 then
					module.applyPose(v9, avatarModel)
				end
			end

			v6((cameraPresetsUtility.GetCameraCFrame_ForAvatarR15Action_LookAtGoldenRatioOfTheHumanoid(
				avatarModel,
				fn,
				v10,
				defineFastInt
			)))
		end

		if ref4.current ~= guid then
			avatarModel:Destroy()
			return
		end

		avatarModel.Parent = ref.current

		if not module2() then
			avatarModel:PivotTo(CFrame.new(0, 0, 0))
			local pivot = avatarModel:GetPivot()
			v6(CFrame.new(pivot.Position + pivot.LookVector * 6, pivot.Position) - Vector3.new(0, 0.75, 0))
		end

		if module4() and p2.avatarModelRef then
			p2.avatarModelRef.current = avatarModel
		end
	end, { ref })

	React.useEffect(function()
		if module.areLooksDifferent(v7, p2.lookDetails) then
			task.spawn(function()
				v8(p2.lookDetails)
			end)
		end
	end, { p2.lookDetails, v7, v8 })

	return React.createElement("ViewportFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		LightColor = Color3.fromRGB(218, 203, 173),
		LightDirection = Vector3.new(-1, -1, 2),
		ref = ref3
	}, {
		WorldModel = React.createElement("WorldModel", { ref = ref }),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v5,
			ref = ref2
		})
	})
end

return LookViewport
