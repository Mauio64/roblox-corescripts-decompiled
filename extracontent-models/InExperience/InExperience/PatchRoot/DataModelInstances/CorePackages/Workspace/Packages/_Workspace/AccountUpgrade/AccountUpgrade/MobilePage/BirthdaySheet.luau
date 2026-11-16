local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)

local BirthdaySheetView = require(script.Parent.BirthdaySheetView)
local useBirthdaySheetViewModel = require(script.Parent.useBirthdaySheetViewModel)

local function OpenSheet(p)
	local v = useBirthdaySheetViewModel(p)
	return React.createElement(BirthdaySheetView, v)
end

local function BirthdaySheet(p)
	if p.isOpen then
		return React.createElement(OpenSheet, p)
	end

	return nil
end

return BirthdaySheet
