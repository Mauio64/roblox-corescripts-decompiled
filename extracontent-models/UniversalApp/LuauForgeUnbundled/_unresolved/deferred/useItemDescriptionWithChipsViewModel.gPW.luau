local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local fFlagAXFixItemDetailsDescriptionSpacing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixItemDetailsDescriptionSpacing
require("@luauforge/bundled/dPt")
local module = require("@luauforge/deferred/gPX")
require("@luauforge/deferred/gPR")
local module2 = require("@luauforge/deferred/gQl")
local module3 = require("@luauforge/deferred/gQn")

local module4 = require("@luauforge/deferred/gQu")

local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens

local function useItemDescriptionWithChipsViewModel(data)
	local theme = useStyle().Theme
	local v6 = module2(useTokens(), data.compactNumberOfLines or 3)

	local descriptionText = data.descriptionText
	local v7 = React.useMemo(function()
		return module.splitDescriptionLinks(descriptionText or "")
	end, { descriptionText })

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v8 = not (state == nil) and v6 < state

	if state == nil or v8 and not state2 then
		state = v6
	end

	local v9 = React.useCallback(function()
		setState2(function(p2): boolean
			return not p2
		end)
	end, {})
	local v10 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local onCanExpandChanged = data.onCanExpandChanged
	React.useEffect(function()
		if onCanExpandChanged then
			onCanExpandChanged(v8)
		end
	end, { v8, onCanExpandChanged })

	local v11 = module4(data.openItemDetails)
	local itemId = data.itemId
	local itemType = data.itemType
	local v12 = React.useCallback(function(p2, p3)
		return React.createElement(module3, {
			url = p2,
			actions = v11,
			itemId = itemId,
			itemType = itemType
		})
	end, { v11, itemId, itemType })

	local iconEmphasis = theme.IconEmphasis
	local v13 = React.useMemo(function()
		return { Color3 = iconEmphasis.Color, Transparency = iconEmphasis.Transparency }
	end, { iconEmphasis })

	return {
		isLoading = descriptionText == nil,
		blocks = v7,
		renderLink = v12,
		visibleHeight = state,
		canExpand = v8,
		isExpanded = state2,
		onToggleExpanded = v9,
		onContentHeightChanged = v10,
		paddingTop = fFlagAXFixItemDetailsDescriptionSpacing and 0 or 30,
		paddingBottom = 5,
		fadeColor = theme.BackgroundDefault.Color,
		chevronStyle = v13,
		LayoutOrder = data.LayoutOrder
	}
end

return useItemDescriptionWithChipsViewModel
