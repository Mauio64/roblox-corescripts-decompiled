local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local dropdownMenu = UIBlox.App.Menu.DropdownMenu

local function ReasonDropdown(props)
	local v5 = React.useMemo(function()
		local mapped = Cryo.Dictionary.map(props.options, function(p2)
			return p2.localizationKey, p2.value
		end)

		return Cryo.Dictionary.union(mapped, {
			ChooseOne = "Feature.ReportAbuse.Label.ChooseOne"
		})
	end, { props.options })

	local v6 = React.useMemo(function()
		return (Cryo.Dictionary.map(props.options, function(p2)
			return p2.descriptionLocalizationKey, p2.value
		end))
	end, { props.options })

	local v7 = useLocalization(v5)
	local v8 = useLocalization(v6)

	local v9 = React.useMemo(function()
		return Cryo.List.map(props.options, function(p2)
			return {
				text = v7[p2.value] or "",
				key = p2.value
			}
		end)
	end, { props.options, v7 })

	local v10 = React.useCallback(function(p2)
		props.setDropdownError(false)
		props.onSelectedAbuseType(p2)

		if props.setDescription then
			props.setDescription(v8[p2] or "")
		end
	end, { props.setDropdownError, props.onSelectedAbuseType })

	return React.createElement(dropdownMenu, {
		placeholder = v7.ChooseOne,
		onChange = v10,
		screenSize = props.screenSize,
		height = UDim.new(0, props.menuItemHeight),
		fixedListHeight = math.min(props.menuItemHeight * #props.options, props.maxHeight),
		errorState = props.isDropdownError,
		showDropShadow = true,
		dropdownMenuListPositionFixed = true,
		cellDatas = v9,
		defaultKey = props.reportCategoryDefaultKey,
		isDisabled = props.isDisabled
	})
end

return ReasonDropdown
