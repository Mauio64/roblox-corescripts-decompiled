local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local BirthdaySheetView = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/BirthdaySheetView")
local useBirthdaySheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/useBirthdaySheetViewModel")

local function OpenSheet(p2)
	local v5 = useBirthdaySheetViewModel(p2)
	return React.createElement(BirthdaySheetView, v5)
end

local function BirthdaySheet(p2)
	if p2.isOpen then
		return React.createElement(OpenSheet, p2)
	end

	return nil
end

return BirthdaySheet
