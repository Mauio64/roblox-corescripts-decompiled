local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ItemInfoRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.ItemInfoRow)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local AppPage = require(Modules.LuaApp.AppPage)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)

require(Modules.AvatarExperience.Common.Types)

local GetFFlagLooksAvatarPDPImageDimensions = require(Modules.AvatarExperience.Flags.GetFFlagLooksAvatarPDPImageDimensions)

return (React.forwardRef(function(t1: {[any]: any}, _) -- line: 39
	-- upvalues: Constants (copy), useAppPolicy (copy), useNavigation (copy), useDispatch (copy), React (copy), CatalogConstants (copy), UrlBuilder (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy), Focusable (copy), GetFFlagLooksAvatarPDPImageDimensions (copy), ItemInfoRow (copy)
	local curator = nil

	if t1.lookDetails and t1.lookDetails.curator then
		curator = t1.lookDetails.curator
	end

	local v20 = curator and curator.id
	local v21 = curator and curator.type
	local v22 = curator and (curator.name and curator.name:lower() ~= Constants.RobloxCreatorName:lower())
	local v23 = t1.lookDetails and t1.lookDetails.totalValue or ""
	local v24 = useAppPolicy(function(p2) -- line: 51
		return p2.getWebViewSupport()
	end)
	local v25 = useNavigation()
	local isTryOn = t1.isTryOn
	local v27 = useDispatch()
	local v28 = React.useCallback(function() -- line: 60
		-- upvalues: v20 (copy), v21 (copy), CatalogConstants (copy), UrlBuilder (copy), isTryOn (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), v27 (copy), NavigateDown (copy), v25 (copy)
		if v20 then
			local v30 = if v21 ~= CatalogConstants.CreatorType.Group then UrlBuilder.user.profile({
				userId = v20
			}) else UrlBuilder.user.group({
				groupId = v20
			})

			if isTryOn then
				local t2 = {
					name = AppPage.GenericWebPage,
					detail = v30,
					extraProps = {
						titleKey = "CommonUI.Features.Label.Profile"
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v12.down(v12.fromLegacyPage(t2))

					return
				end

				v27(NavigateDown(t2))

				return
			end

			v25.navigate(AppPage.GenericWebPage, {
				detail = v30,
				extraProps = {
					titleKey = "CommonUI.Features.Label.Profile"
				}
			})
		end
	end, {
		v20,
		v21,
		isTryOn,
		v27
	})

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = if not GetFFlagLooksAvatarPDPImageDimensions() then nil else React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, t1.innerPadding),
			PaddingRight = UDim.new(0, t1.innerPadding)
		}),
		Curator = if not v22 then nil else React.createElement(ItemInfoRow, {
			infoName = "Feature.Avatar.Label.By",
			LayoutOrder = 2,
			infoData = curator.name,
			onActivate = if not not v24 and not t1.disableInteractions then v28 else nil,
			hasVerifiedBadge = not not curator and curator.hasVerifiedBadge
		}),
		TotalValue = React.createElement(ItemInfoRow, {
			infoName = "Feature.Catalog.Label.Filter.TotalValue",
			LayoutOrder = 3,
			infoData = CatalogConstants.RobloxEmoji.Robux .. v23
		})
	})
end))
