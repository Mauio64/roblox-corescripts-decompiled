local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local mutedError = require(Modules.LuaApp.mutedError)
local React = require(CorePackages.Packages.React)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local ItemViewportUtils = require(script.Parent.ItemViewportUtils)
local useItemViewportInteractions = require(script.Parent.useItemViewportInteractions)
local GetFFlagAXFixItemViewportErrors = require(Modules.AvatarExperience.Flags.GetFFlagAXFixItemViewportErrors)
local GetFFlagAXSupportShoesInItemViewport = require(Modules.AvatarExperience.Flags.GetFFlagAXSupportShoesInItemViewport)
local color3 = Color3.fromRGB(218, 203, 173)

local function ItemViewport(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), useItemViewportInteractions (copy), GetFFlagAXSupportShoesInItemViewport (copy), HttpService (copy), Constants (copy), ItemViewportUtils (copy), sendAXCounterV2 (copy), GetFFlagAXFixItemViewportErrors (copy), mutedError (copy), color3 (copy), Loading (copy), IconSize (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v20 = React.useRef(nil)
	local v21 = React.useRef(nil)
	local v22 = React.useRef(nil)
	local v23 = React.useRef("")
	local v24 = React.useRef(0)
	local v25, v26 = React.useState(true)
	local v27 = not v25
	local v28 = useItemViewportInteractions({
		setParentScrollingEnabled = t1.setParentScrollingEnabled,
		defaultCameraDistanceRef = v24
	})
	local v29 = React.useCallback(not GetFFlagAXSupportShoesInItemViewport() and function(s1: string, s2: string, s3: string?, s4: string?) -- line: 116
		-- upvalues: v26 (copy), v20 (copy), HttpService (copy), v23 (copy), Constants (copy), ItemViewportUtils (copy), t1 (copy), sendAXCounterV2 (copy), GetFFlagAXFixItemViewportErrors (copy), mutedError (copy), v21 (copy), v24 (copy)
		v26(true)

		if v20.current then
			v20.current:ClearAllChildren()
		end

		local guid = HttpService:GenerateGUID(false)

		v23.current = guid

		local ok, result = pcall(function() -- line: 129
			-- upvalues: s2 (copy), Constants (copy), s1 (copy), ItemViewportUtils (copy), s3 (copy), s4 (copy)
			if s2 == Constants.ItemType.Asset and tonumber(s1) then
				return ItemViewportUtils.getAssetModel((tonumber(s1)))
			end

			if s2 == Constants.ItemType.Bundle and s3 and s4 and tonumber(s4) then
				return ItemViewportUtils.getBundleModel(s3, (tonumber(s4)))
			end

			return nil
		end)

		if not ok or not result then
			if t1.onLoadingFailed then
				t1.onLoadingFailed()
			end

			sendAXCounterV2("ItemViewportLoadingFailed")

			if not _G.__TESTEZ_RUNNING_TEST__ then
				warn(`ItemViewport: failed to load 3D model for item { s1 }`, result)

				if not GetFFlagAXFixItemViewportErrors() then
					mutedError(`ItemViewport: failed to load 3D model. itemId:{ s1 } itemType:{ s2 }`)
				end
			end

			return
		end

		if guid ~= v23.current then
			result:Destroy()

			return
		end

		local v45 = not v21.current and 70 or v21.current.MaxAxisFieldOfView

		v24.current = ItemViewportUtils.getCameraDistance(result, v45)
		result.Parent = v20.current
		v26(false)
	end or function(s5: string, s6: string, s7: string?, t2: {[any]: any}?) -- line: 64
		-- upvalues: v26 (copy), v20 (copy), HttpService (copy), v23 (copy), Constants (copy), ItemViewportUtils (copy), t1 (copy), sendAXCounterV2 (copy), GetFFlagAXFixItemViewportErrors (copy), mutedError (copy), v21 (copy), v24 (copy)
		v26(true)

		if v20.current then
			v20.current:ClearAllChildren()
		end

		local guid = HttpService:GenerateGUID(false)

		v23.current = guid

		local ok, result = pcall(function() -- line: 76
			-- upvalues: s6 (copy), Constants (copy), s5 (copy), ItemViewportUtils (copy), s7 (copy), t2 (copy)
			if s6 == Constants.ItemType.Asset and tonumber(s5) then
				return ItemViewportUtils.getAssetModel((tonumber(s5)))
			end

			if s6 == Constants.ItemType.Bundle and s7 and t2 then
				if s7 == Constants.BundleTypeIdStrings.Shoes then
					return ItemViewportUtils.getShoesModel(t2)
				end

				local v46 = s7 == Constants.BundleTypeIdStrings.DynamicHead

				return ItemViewportUtils.getAvatarModel(t2, v46)
			end

			return nil
		end)

		if not ok or not result then
			if t1.onLoadingFailed then
				t1.onLoadingFailed()
			end

			sendAXCounterV2("ItemViewportLoadingFailed")

			if not _G.__TESTEZ_RUNNING_TEST__ then
				warn(`ItemViewport: failed to load 3D model for item { s5 }`, result)

				if not GetFFlagAXFixItemViewportErrors() then
					mutedError(`ItemViewport: failed to load 3D model. itemId:{ s5 } itemType:{ s6 }`)
				end
			end

			return
		end

		if guid ~= v23.current then
			result:Destroy()

			return
		end

		local v37 = not v21.current and 70 or v21.current.MaxAxisFieldOfView

		v24.current = ItemViewportUtils.getCameraDistance(result, v37)
		result.Parent = v20.current
		v26(false)
	end, { t1.onLoadingFailed })

	if GetFFlagAXSupportShoesInItemViewport() then
		React.useEffect(function() -- line: 174
			-- upvalues: v29 (copy), t1 (copy)
			task.spawn(function() -- line: 175
				-- upvalues: v29 (copy), t1 (copy)
				v29(t1.itemId, t1.itemType, t1.bundleType, t1.bundleItems)
			end)
		end, {
			t1.itemId,
			t1.itemType,
			t1.bundleType,
			t1.bundleItems,
			v29
		})
	else
		React.useEffect(function() -- line: 180
			-- upvalues: v29 (copy), t1 (copy)
			task.spawn(function() -- line: 181
				-- upvalues: v29 (copy), t1 (copy)
				v29(t1.itemId, t1.itemType, t1.bundleType, t1.outfitId)
			end)
		end, {
			t1.itemId,
			t1.itemType,
			t1.bundleType,
			t1.outfitId,
			v29
		})
	end

	React.useLayoutEffect(function() -- line: 188
		-- upvalues: v22 (copy), v21 (copy)
		if v22.current then
			v22.current.CurrentCamera = v21.current
		end
	end, {})

	return React.createElement("ViewportFrame", {
		Size = t1.size or UDim2.fromScale(1, 1),
		Position = t1.position,
		AnchorPoint = t1.anchorPoint,
		LightColor = color3,
		LightDirection = Vector3.new(-1, -1, 2),
		BackgroundTransparency = 1,
		ref = v22,
		[React.Event.InputBegan] = if not v27 then nil else v28.onInputBegan,
		[React.Event.MouseWheelForward] = if not v27 then nil else v28.onMouseWheelForward,
		[React.Event.MouseWheelBackward] = if not v27 then nil else v28.onMouseWheelBackward,
		[React.Event.MouseEnter] = if not v27 then nil else v28.onMouseEnter,
		[React.Event.MouseLeave] = if not v27 then nil else v28.onMouseLeave
	}, {
		WorldModel = React.createElement("WorldModel", {
			ref = v20
		}),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			CFrame = v28.cameraCFrame,
			ref = v21
		}),
		LoadingSpinner = if not v25 then nil else React.createElement(Loading, {
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large,
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		InputChangedConnection = if not v27 then nil else React.createElement(ExternalEventConnection, {
			event = UserInputService.InputChanged,
			callback = v28.onInputChanged
		}),
		InputEndedConnection = if not v27 then nil else React.createElement(ExternalEventConnection, {
			event = UserInputService.InputEnded,
			callback = v28.onInputEnded
		}),
		TouchPinchConnection = if not v27 then nil else React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchPinch,
			callback = v28.onTouchPinch
		})
	})
end

return ItemViewport
