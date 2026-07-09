local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local UIBlox = require(Parent.UIBlox)

require(script.Parent.Parent.Models.CommunityInfo)

local getCommunityUrl = require(script.Parent.Parent.Utils.getCommunityUrl)
local GetCommunityInviteUrl = require(script.Parent.Parent.Requests.GetCommunityInviteUrl)
local GuildedLogoAsset2x = require(script.Parent.Parent.constants).GuildedLogoAsset2x
local constants = require(script.Parent.Parent.Analytics.constants)
local clickCommunityLinkEvent = require(script.Parent.Parent.Analytics).Events.clickCommunityLinkEvent
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetFFlagLuaAppFixCommunityLinksRedirect = require(script.Parent.Parent.Flags.GetFFlagLuaAppFixCommunityLinksRedirect)

local function CommunityLinkBanner(t1: {[any]: any}) -- line: 55
	-- upvalues: useRoactService (copy), AppLinking (copy), AppEventIngestService (copy), RoactNetworking (copy), useStyle (copy), useLocalization (copy), useDispatch (copy), React (copy), SetCentralOverlay (copy), CentralOverlayType (copy), GetFFlagLuaAppFixCommunityLinksRedirect (copy), GetCommunityInviteUrl (copy), getCommunityUrl (copy), clickCommunityLinkEvent (copy), constants (copy), Interactable (copy), Dash (copy), GuildedLogoAsset2x (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy)
	local v26 = useRoactService(AppLinking)
	local v27 = useRoactService(AppEventIngestService)
	local v28 = useRoactService(RoactNetworking)
	local v29 = useStyle()
	local v30 = useLocalization({
		ViewLabel = "Feature.CommunityLinks.Label.ViewButton",
		DescriptionCommunityDefault = "Feature.CommunityLinks.Description.CommunityDefault"
	})
	local v31 = useDispatch()
	local v32 = React.useCallback(function(p1) -- line: 68
		-- upvalues: v31 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		v31(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = p1
		}))
	end, { v31 })
	local v33 = React.useCallback(function() -- line: 72
		-- upvalues: v31 (copy), SetCentralOverlay (copy)
		v31(SetCentralOverlay())
	end, { v31 })
	local communityId = t1.communityInfo.communityId
	local v35 = React.useCallback(function() -- line: 78
		-- upvalues: GetFFlagLuaAppFixCommunityLinksRedirect (copy), GetCommunityInviteUrl (copy), v28 (copy), communityId (copy), v26 (copy), getCommunityUrl (copy), v33 (copy), clickCommunityLinkEvent (copy), v27 (copy), constants (copy), t1 (copy)
		if GetFFlagLuaAppFixCommunityLinksRedirect() then
			GetCommunityInviteUrl(v28, communityId):andThen(function(p2) -- line: 80
				-- upvalues: v26 (copy)
				local responseBody = p2.responseBody

				v26:openURL(responseBody)
			end)
		else
			local v44 = getCommunityUrl(communityId)

			v26:openURL(v44)
		end

		v33()
		clickCommunityLinkEvent(v27, constants.Context.CommunityLinkBanner, {
			entityType = "universe",
			guildedServerId = communityId,
			entityId = t1.universeId
		})
	end, {
		communityId,
		v26
	})
	local v36 = React.useCallback(function() -- line: 96
		-- upvalues: v32 (copy), v35 (copy)
		v32(v35)
	end, {
		v32,
		v35
	})
	local v37, v38 = React.useState(false)
	local v39 = React.useCallback(function(p3) -- line: 102
		-- upvalues: v38 (copy)
		v38(p3.AbsoluteSize.X < 600)
	end, {})
	local v40 = not v37 and 72 or 64
	local v41 = not v37
	local v42 = -(v40 + 16 + (not v41 and 0 or 136))

	return React.createElement(Interactable, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v29.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v29.Theme.BackgroundUIDefault.Transparency,
		ClipsDescendants = true,
		[React.Change.AbsoluteSize] = v39,
		[React.Event.Activated] = v36,
		onStateChanged = Dash.noop,
		LayoutOrder = t1.layoutOrder
	}, {
		BorderRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 16),
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v40, v40),
			Image = GuildedLogoAsset2x
		}, {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		}),
		Info = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, v42, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Name = React.createElement(StyledTextLabel, {
				richText = true,
				fluidSizing = false,
				layoutOrder = 1,
				text = t1.communityInfo.name,
				size = UDim2.new(1, 0, 0, 18),
				textYAlignment = Enum.TextYAlignment.Top,
				textTruncate = Enum.TextTruncate.AtEnd,
				fontStyle = v29.Font.Header2,
				colorStyle = v29.Theme.TextEmphasis
			}),
			Description = React.createElement(StyledTextLabel, {
				lineHeight = 1.15,
				richText = false,
				fluidSizing = false,
				layoutOrder = 2,
				text = t1.communityInfo.description or v30.DescriptionCommunityDefault:gsub("{experienceName}", t1.linkedEntityName),
				size = UDim2.new(1, 0, 0, 44),
				textYAlignment = Enum.TextYAlignment.Center,
				textTruncate = Enum.TextTruncate.AtEnd,
				fontStyle = v29.Font.Body,
				colorStyle = v29.Theme.TextDefault
			})
		}),
		ViewButton = if not v41 then nil else React.createElement(Button, {
			layoutOrder = 3,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.fromOffset(120, 28),
			text = v30.ViewLabel,
			onActivated = v36
		})
	})
end

return CommunityLinkBanner
