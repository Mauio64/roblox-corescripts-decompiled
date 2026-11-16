local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

require(script.Parent.SheetType)

return React.createContext({
	sheetHeightAvailable = nil,
	setSheetHeightAvailable = function(_: number)
		error("No SheetContext available")
	end,
	actionsHeight = nil,
	setActionsHeight = function(_: number)
		error("No SheetContext available")
	end,
	hasActionsDivider = nil,
	setHasActionsDivider = function(_: boolean)
		error("No SheetContext available")
	end,
	sheetContentHeight = nil,
	setSheetContentHeight = function(_: number)
		error("No SheetContext available")
	end,
	safeAreaPadding = nil,
	bottomPadding = nil,
	innerScrollingEnabled = nil,
	innerScrollY = nil,
	setInnerScrollY = function(_: number)
		error("No SheetContext available")
	end,
	hasHeader = nil,
	setHasHeader = function(_: boolean)
		error("No SheetContext available")
	end,
	hasFullBleed = false,
	fullBleedHeight = nil,
	setFullBleedHeight = function(_: number)
		error("No SheetContext available")
	end,
	hasRadius = true,
	closeSheet = nil,
	sheetType = nil,
	innerSurface = nil,
	testId = nil,
	closeAffordanceRef = nil,
	contentStartRef = nil,
	setContentStartRef = function(_) end
})
