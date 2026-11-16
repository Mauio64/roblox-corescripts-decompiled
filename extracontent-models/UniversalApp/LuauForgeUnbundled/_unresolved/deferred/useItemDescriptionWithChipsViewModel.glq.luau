local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local fFlagAXFixItemDetailsDescriptionSpacing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixItemDetailsDescriptionSpacing
require("@luauforge/bundled/dMd")
local module = require("@luauforge/deferred/glr")
require("@luauforge/deferred/gll")
local module2 = require("@luauforge/deferred/glF")
local module3 = require("@luauforge/deferred/glH")

local module4 = require("@luauforge/deferred/glO")

local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens

local function useItemDescriptionWithChipsViewModel(data)
	local theme = useStyle().Theme
	local v5 = module2(useTokens(), data.compactNumberOfLines or 3)

	local descriptionText = data.descriptionText
	local v6 = React.useMemo(function()
		return module.splitDescriptionLinks(descriptionText or "")
	end, { descriptionText })

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v7 = not (state == nil) and v5 < state

	if state == nil or v7 and not state2 then
		state = v5
	end

	local v8 = React.useCallback(function()
		setState2(function(p2): boolean
			return not p2
		end)
	end, {})
	local v9 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local onCanExpandChanged = data.onCanExpandChanged
	React.useEffect(function()
		if onCanExpandChanged then
			onCanExpandChanged(v7)
		end
	end, { v7, onCanExpandChanged })

	local v10 = module4(data.openItemDetails)
	local itemId = data.itemId
	local itemType = data.itemType
	local v11 = React.useCallback(function(p2, p3)
		return React.createElement(module3, {
			url = p2,
			actions = v10,
			itemId = itemId,
			itemType = itemType
		})
	end, { v10, itemId, itemType })

	local iconEmphasis = theme.IconEmphasis
	local v12 = React.useMemo(function()
		return { Color3 = iconEmphasis.Color, Transparency = iconEmphasis.Transparency }
	end, { iconEmphasis })

	return {
		isLoading = descriptionText == nil,
		blocks = v6,
		renderLink = v11,
		visibleHeight = state,
		canExpand = v7,
		isExpanded = state2,
		onToggleExpanded = v8,
		onContentHeightChanged = v9,
		paddingTop = fFlagAXFixItemDetailsDescriptionSpacing and 0 or 30,
		paddingBottom = 5,
		fadeColor = theme.BackgroundDefault.Color,
		chevronStyle = v12,
		LayoutOrder = data.LayoutOrder
	}
end

return useItemDescriptionWithChipsViewModel
