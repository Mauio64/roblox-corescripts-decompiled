local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.UIBlox)

local GamepadNavigationDialog = require(script.Parent.GamepadNavigationDialog)

React.PureComponent:extend("GamepadNavigationDialogShowCounter")

local function shouldShowBasedOnCountInAppStorage(p1, p2) -- line: 20
	-- upvalues: AppStorageService (copy), HttpService (copy)
	local Item = AppStorageService:GetItem(p1)
	local Item2 = AppStorageService:GetItem("UserId")
	local ok, result = pcall(function() -- line: 23
		-- upvalues: HttpService (copy), Item (copy)
		return HttpService:JSONDecode(Item)
	end)

	if not ok or type(result) ~= "table" then
		result = {}
	end

	local v15 = result[Item2]

	if type(v15) ~= "number" then
		v15 = 0
	end

	result[Item2] = v15 + 1

	return v15 < p2, HttpService:JSONEncode(result)
end
local function GamepadNavigationDialogTextButton(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), GamepadNavigationDialog (copy)
	React.useEffect(function() -- line: 44
		-- upvalues: t1 (copy)
		return t1.onCleanup
	end, {})

	return React.createElement("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		[React.Event.Activated] = t1.onDismissed
	}, {
		GamepadNavigationDialog = React.createElement(GamepadNavigationDialog, {
			selectButtonDismissesGamepadNavigationDialog = t1.selectButtonDismissesGamepadNavigationDialog,
			onDismissed = t1.onDismissed
		})
	})
end
local function GamepadNavigationDialogShowCounter(t2: {[any]: any}) -- line: 62
	-- upvalues: shouldShowBasedOnCountInAppStorage (copy), React (copy), GamepadNavigationDialogTextButton (copy), AppStorageService (copy)
	if not t2.isGamepadNavigationDialogEnabled or not t2.isGamepadNavigationDialogOpen then
		return nil
	end

	local v18, v19 = shouldShowBasedOnCountInAppStorage(t2.appStorageKey, t2.maxShownCount)

	if not v18 then
		return nil
	end

	return React.createElement(GamepadNavigationDialogTextButton, {
		selectButtonDismissesGamepadNavigationDialog = t2.selectButtonDismissesGamepadNavigationDialog,
		onDismissed = function() -- line: 74
			-- upvalues: t2 (copy)
			t2.SetGamepadNavigationDialogOpen(false)
		end,
		onCleanup = function() -- line: 77
			-- upvalues: AppStorageService (copy), t2 (copy), v19 (copy)
			AppStorageService:SetItem(t2.appStorageKey, v19)
			AppStorageService:Flush()
		end
	})
end

return GamepadNavigationDialogShowCounter
