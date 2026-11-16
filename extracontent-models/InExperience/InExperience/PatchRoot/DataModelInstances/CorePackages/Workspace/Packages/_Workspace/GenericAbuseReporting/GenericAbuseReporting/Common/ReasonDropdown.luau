local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local DropdownMenu = UIBlox.App.Menu.DropdownMenu

local function ReasonDropdown(props)
	local v = React.useMemo(function()
		local mapped = Cryo.Dictionary.map(props.options, function(p)
			return p.localizationKey, p.value
		end)

		return Cryo.Dictionary.union(mapped, { ChooseOne = "Feature.ReportAbuse.Label.ChooseOne" })
	end, { props.options })

	local v2 = React.useMemo(function()
		return (Cryo.Dictionary.map(props.options, function(p)
			return p.descriptionLocalizationKey, p.value
		end))
	end, { props.options })

	local v3 = useLocalization(v)
	local v4 = useLocalization(v2)

	local cellDatas = React.useMemo(function()
		return Cryo.List.map(props.options, function(p)
			return {
				text = v3[p.value] or "",
				key = p.value
			}
		end)
	end, { props.options, v3 })

	local onChange = React.useCallback(function(p)
		props.setDropdownError(false)
		props.onSelectedAbuseType(p)

		if props.setDescription then
			props.setDescription(v4[p] or "")
		end
	end, { props.setDropdownError, props.onSelectedAbuseType })

	return React.createElement(DropdownMenu, {
		placeholder = v3.ChooseOne,
		onChange = onChange,
		screenSize = props.screenSize,
		height = UDim.new(0, props.menuItemHeight),
		fixedListHeight = math.min(props.menuItemHeight * #props.options, props.maxHeight),
		errorState = props.isDropdownError,
		showDropShadow = true,
		dropdownMenuListPositionFixed = true,
		cellDatas = cellDatas,
		defaultKey = props.reportCategoryDefaultKey,
		isDisabled = props.isDisabled
	})
end

return ReasonDropdown
