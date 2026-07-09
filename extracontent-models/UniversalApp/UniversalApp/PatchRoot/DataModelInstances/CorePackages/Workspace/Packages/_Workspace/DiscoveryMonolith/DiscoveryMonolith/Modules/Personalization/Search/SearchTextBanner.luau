local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local React = require(Parent.React)
local useStyle = require(Parent.UIBlox).Core.Style.useStyle
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local DiscoveryUtils = require(Parent.DiscoveryUtils)
local extractAndStyleRichTextLinks = DiscoveryUtils.extractAndStyleRichTextLinks
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local CentralOverlay = require(Parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useStyle (copy), useSelector (copy), React (copy), DiscoveryUtils (copy), useRoactService (copy), AppLinking (copy), extractAndStyleRichTextLinks (copy), useDispatch (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy)
	local v15 = useStyle()
	local Font = v15.Font
	local BodyFont = Font.Body.Font
	local v18 = Font.BaseSize * Font.Header2.RelativeSize
	local v19 = useSelector(function(p1) -- line: 32
		return p1.ScreenSize
	end)
	local v20, v21 = React.useState(v19)
	local v22 = v20.X and DiscoveryUtils.getPageSideMargin(v20.X) or 0
	local v23 = t1.sidePadding or v22
	local v24 = useRoactService(AppLinking)
	local v25 = React.useMemo(function() -- line: 48
		-- upvalues: extractAndStyleRichTextLinks (copy), t1 (copy)
		local v30, v31 = extractAndStyleRichTextLinks(t1.text)

		return {
			link = if not (#v30 > 0) then nil else v30[1],
			styledText = v31
		}
	end, { t1.text })
	local v26 = useDispatch()
	local v27 = React.useCallback(function() -- line: 60
		-- upvalues: v26 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v24 (copy), v25 (copy), CloseCentralOverlay (copy)
		v26(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = function() -- line: 62
				-- upvalues: v24 (copy), v25 (copy), v26 (copy), CloseCentralOverlay (copy)
				v24:openURL(v25.link)
				v26(CloseCentralOverlay())
			end
		}))
	end, {
		v25.link,
		v26
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = v15.Theme.BackgroundContrast.Transparency,
		BackgroundColor3 = v15.Theme.BackgroundContrast.Color,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p2) -- line: 37
			-- upvalues: v21 (copy)
			if p2 then
				v21(p2.AbsoluteSize)
			end
		end
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v23),
			PaddingRight = UDim.new(0, v23),
			PaddingTop = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16)
		}),
		BannerText = React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			RichText = true,
			Size = UDim2.new(1, 0, 0, 32),
			Text = v25.styledText,
			TextSize = v18,
			Font = BodyFont,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = v15.Theme.TextEmphasis.Color,
			Active = v25.link ~= nil,
			Selectable = v25.link ~= nil,
			[React.Event.Activated] = if not v25.link then nil else v27
		})
	})
end
