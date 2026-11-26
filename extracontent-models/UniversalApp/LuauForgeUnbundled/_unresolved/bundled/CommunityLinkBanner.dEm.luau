local module = require("@luauforge/bundled/dEn")
local module2 = require("@luauforge/bundled/dEo")
local module3 = require("@luauforge/bundled/dEp")

require("@luauforge/bundled/dEq")
local module4 = require("@luauforge/bundled/dEs")
local module5 = require("@luauforge/bundled/dEv")
local guildedLogoAsset2x = require("@luauforge/bundled/dEw").GuildedLogoAsset2x
local module6 = require("@luauforge/bundled/dEx")
local clickCommunityLinkEvent = require("@luauforge/bundled/dEy").Events.clickCommunityLinkEvent

local appLinking = require("@luauforge/bundled/dEC").AppLinking
local appEventIngestService = require("@luauforge/bundled/dEC").AppEventIngestService
local roactNetworking = require("@luauforge/bundled/dEC").RoactNetworking
local setCentralOverlay = require("@luauforge/bundled/dED").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/dEE").CentralOverlayType

local useDispatch = require("@luauforge/bundled/dEF").Hooks.RoactRodux.useDispatch
local useLocalization = require("@luauforge/bundled/dEG").Hooks.useLocalization
local useRoactService = require("@luauforge/bundled/dEH").useRoactService
local useStyle = module3.Core.Style.useStyle

local interactable = module3.Core.Control.Interactable
local styledTextLabel = module3.App.Text.StyledTextLabel
local button = module3.App.Button.Button
local buttonType = module3.App.Button.Enum.ButtonType

local module7 = require("@luauforge/bundled/dEI")

local function CommunityLinkBanner(props)
	local v5 = useRoactService(appLinking)
	local v6 = useRoactService(appEventIngestService)
	local v7 = useRoactService(roactNetworking)

	local v8 = useStyle()
	local v9 = useLocalization({
		ViewLabel = "Feature.CommunityLinks.Label.ViewButton",
		DescriptionCommunityDefault = "Feature.CommunityLinks.Description.CommunityDefault"
	})

	local v10 = useDispatch()

	local v11 = module.useCallback(function(p2)
		v10(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, { continueFunc = p2 }))
	end, { v10 })

	local v12 = module.useCallback(function()
		v10(setCentralOverlay())
	end, { v10 })

	local communityId = props.communityInfo.communityId

	local v13 = module.useCallback(function()
		if module7() then
			module5(v7, communityId):andThen(function(p2)
				v5:openURL(p2.responseBody)
			end)
		else
			v5:openURL((module4(communityId)))
		end

		v12()
		clickCommunityLinkEvent(v6, module6.Context.CommunityLinkBanner, {
			guildedServerId = communityId,
			entityType = "universe",
			entityId = props.universeId
		})
	end, { communityId, v5 })

	local v14 = module.useCallback(function()
		v11(v13)
	end, { v11, v13 })

	local state, setState = module.useState(false)

	local v15 = module.useCallback(function(p2)
		setState(p2.AbsoluteSize.X < 600)
	end, {})
	local v16 = state and 64 or 72
	local v17 = not state

	local v18 = -(v16 + 16 + (v17 and 136 or 0))

	local createElement = module.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v8.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v8.Theme.BackgroundUIDefault.Transparency,
		ClipsDescendants = true,
		[module.Change.AbsoluteSize] = v15,
		[module.Event.Activated] = v14,
		onStateChanged = module2.noop,
		LayoutOrder = props.layoutOrder
	}
	local v21 = {
		BorderRadius = module.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 16),
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = module.createElement(
			"ImageLabel",
			{
				Size = UDim2.fromOffset(v16, v16),
				BackgroundTransparency = 1,
				Image = guildedLogoAsset2x,
				LayoutOrder = 1
			},
			{
				BorderRadius = module.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				})
			}
		),
		Info = module.createElement(
			"Frame",
			{
				Size = UDim2.new(1, v18, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 8),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Name = module.createElement(styledTextLabel, {
					text = props.communityInfo.name,
					size = UDim2.new(1, 0, 0, 18),
					textYAlignment = Enum.TextYAlignment.Top,
					textTruncate = Enum.TextTruncate.AtEnd,
					fontStyle = v8.Font.Header2,
					colorStyle = v8.Theme.TextEmphasis,
					richText = true,
					fluidSizing = false,
					layoutOrder = 1
				}),
				Description = module.createElement(styledTextLabel, {
					text = props.communityInfo.description or v9.DescriptionCommunityDefault:gsub(
						"{experienceName}",
						props.linkedEntityName
					),
					size = UDim2.new(1, 0, 0, 44),
					lineHeight = 1.15,
					textYAlignment = Enum.TextYAlignment.Center,
					textTruncate = Enum.TextTruncate.AtEnd,
					fontStyle = v8.Font.Body,
					colorStyle = v8.Theme.TextDefault,
					richText = false,
					fluidSizing = false,
					layoutOrder = 2
				})
			}
		),
		ViewButton = 0
	}

	local v22 = if v17 then module.createElement(button, {
		buttonType = buttonType.PrimarySystem,
		size = UDim2.fromOffset(120, 28),
		text = v9.ViewLabel,
		onActivated = v14,
		layoutOrder = 3
	}) else nil
	v21.ViewButton = v22
	return createElement(interactable, v20, v21)
end

return CommunityLinkBanner
