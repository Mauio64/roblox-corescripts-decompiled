local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.UIBlox)
local GamepadNavigationDialog = require(script.Parent.GamepadNavigationDialog)

React.PureComponent:extend("GamepadNavigationDialogShowCounter")

local function shouldShowBasedOnCountInAppStorage(appStorageKey, maxShownCount)
	local item = AppStorageService:GetItem(appStorageKey)
	local item2 = AppStorageService:GetItem("UserId")
	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	local v = (not success or type(result) ~= "table") and {} or result

	local v2 = v[item2]
	local v3 = type(v2) ~= "number" and 0 or v2

	v[item2] = v3 + 1
	return v3 < maxShownCount, HttpService:JSONEncode(v)
end

local function GamepadNavigationDialogTextButton(props)
	React.useEffect(function()
		return props.onCleanup
	end, {})

	return React.createElement("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Event.Activated] = props.onDismissed
	}, {
		GamepadNavigationDialog = React.createElement(GamepadNavigationDialog, {
			selectButtonDismissesGamepadNavigationDialog = props.selectButtonDismissesGamepadNavigationDialog,
			onDismissed = props.onDismissed
		})
	})
end

local function GamepadNavigationDialogShowCounter(props)
	if not (props.isGamepadNavigationDialogEnabled and props.isGamepadNavigationDialogOpen) then
		return nil
	end

	local v, v2 = shouldShowBasedOnCountInAppStorage(props.appStorageKey, props.maxShownCount)

	if v then
		return React.createElement(GamepadNavigationDialogTextButton, {
			selectButtonDismissesGamepadNavigationDialog = props.selectButtonDismissesGamepadNavigationDialog,
			onDismissed = function()
				props.SetGamepadNavigationDialogOpen(false)
			end,
			onCleanup = function()
				AppStorageService:SetItem(props.appStorageKey, v2)
				AppStorageService:Flush()
			end
		})
	end

	return nil
end

return GamepadNavigationDialogShowCounter
