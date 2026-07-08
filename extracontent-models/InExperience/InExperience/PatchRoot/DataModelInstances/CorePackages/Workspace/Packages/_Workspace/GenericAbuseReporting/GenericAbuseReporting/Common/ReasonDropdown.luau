local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local DropdownMenu = UIBlox.App.Menu.DropdownMenu

local function ReasonDropdown(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), Cryo (copy), useLocalization (copy), DropdownMenu (copy)
	local v9 = React.useMemo(function() -- line: 31
		-- upvalues: Cryo (copy), t1 (copy)
		local v15 = Cryo.Dictionary.map(t1.options, function(p1) -- line: 32
			return p1.localizationKey, p1.value
		end)

		return Cryo.Dictionary.union(v15, {
			ChooseOne = "Feature.ReportAbuse.Label.ChooseOne"
		})
	end, { t1.options })
	local v10 = React.useMemo(function() -- line: 41
		-- upvalues: Cryo (copy), t1 (copy)
		return (Cryo.Dictionary.map(t1.options, function(p2) -- line: 42
			return p2.descriptionLocalizationKey, p2.value
		end))
	end, { t1.options })
	local v11 = useLocalization(v9)
	local v12 = useLocalization(v10)
	local v13 = React.useMemo(function() -- line: 51
		-- upvalues: Cryo (copy), t1 (copy), v11 (copy)
		return Cryo.List.map(t1.options, function(p3) -- line: 52
			-- upvalues: v11 (copy)
			return {
				text = v11[p3.value] or "",
				key = p3.value
			}
		end)
	end, {
		t1.options,
		v11
	})
	local v14 = React.useCallback(function(p4) -- line: 60
		-- upvalues: t1 (copy), v12 (copy)
		t1.setDropdownError(false)
		t1.onSelectedAbuseType(p4)

		if t1.setDescription then
			t1.setDescription(v12[p4] or "")
		end
	end, {
		t1.setDropdownError,
		t1.onSelectedAbuseType
	})

	return React.createElement(DropdownMenu, {
		showDropShadow = true,
		dropdownMenuListPositionFixed = true,
		placeholder = v11.ChooseOne,
		onChange = v14,
		screenSize = t1.screenSize,
		height = UDim.new(0, t1.menuItemHeight),
		fixedListHeight = math.min(t1.menuItemHeight * #t1.options, t1.maxHeight),
		errorState = t1.isDropdownError,
		cellDatas = v13,
		defaultKey = t1.reportCategoryDefaultKey,
		isDisabled = t1.isDisabled
	})
end

return ReasonDropdown
