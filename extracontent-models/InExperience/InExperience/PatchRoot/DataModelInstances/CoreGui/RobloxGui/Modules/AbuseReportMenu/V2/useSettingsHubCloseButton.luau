local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)

local function useSettingsHubCloseButton(callback, flag: boolean)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		local v

		if callback then
			v = callback()
		end

		local v2

		if v then
			v2 = v.PageTitleCloseButton
		end

		setState(v2)
	end, { callback, flag })

	React.useEffect(function()
		if not state then
			setState2(false)
			return nil
		end

		local function updateIsSelected() -- 1 equivalent call inferred from this helper
			setState2(GuiService.SelectedCoreObject == state)
		end

		updateIsSelected() -- inferred equivalent call
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(updateIsSelected)

		return function()
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end, { state })

	return state, state2
end

return useSettingsHubCloseButton
