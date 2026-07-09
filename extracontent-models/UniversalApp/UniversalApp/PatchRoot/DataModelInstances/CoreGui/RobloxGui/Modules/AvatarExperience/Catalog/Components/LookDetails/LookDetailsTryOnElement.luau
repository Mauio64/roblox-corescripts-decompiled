local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = UIBlox.Core.Style.withStyle
local ItemTile = UIBlox.Tile.ItemTile
local ItemTileEnums = UIBlox.Tile.ItemTileEnums
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Colors = UIBlox.App.Style.Colors
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local getIconRichText = Foundation.Utility.getIconRichText
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local SetEquippedInTryOnManagerThunk = require(Modules.AvatarExperience.Common.Thunks.SetEquippedInTryOnManagerThunk)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local SetSelectedTimedOption = AvatarExperienceRodux.Actions.SetSelectedTimedOption
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.Types)

local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Utils = require(Modules.AvatarExperience.Common.Utils)
local WearTimeSelectedOptionInList = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions).WearTimeSelectedOptionInList
local FlexLayout = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.FlexLayout
local v42 = Images["icons/common/robux"]
local v43 = Images["icons/status/error_large"]
local v44 = Roact.PureComponent:extend("LookDetailsTryOnElement")

v44.validateProps = t.strictInterface({
	tryOnItem = t.optional(t.table),
	itemInfo = t.table,
	layoutOrder = t.optional(t.number),
	allowAutomaticPeekViewStateChanges = t.optional(t.boolean),
	elementRef = t.optional(t.table),
	horizontalPadding = t.optional(t.number),
	disableInteractions = t.optional(t.boolean),
	forceShowPrice = t.optional(t.boolean),
	tokens = t.any,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	playerMembership = t.optional(t.enum(Enum.MembershipType)),
	setEquippedInTryOnManager = t.callback,
	setTryOnManagerPeekViewState = t.optional(t.callback),
	setSelectedTimedOption = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	localization = t.table,
	navigation = t.table
})

function v44.init(p1) -- line: 107
	-- upvalues: Utils (copy), PeekViewState (copy)
	function p1.onTileActivated() -- line: 108
		-- upvalues: p1 (copy), Utils (copy), PeekViewState (copy)
		local tryOnItem = p1.props.tryOnItem

		if not tryOnItem then
			return
		end

		local itemInfo = p1.props.itemInfo

		if not Utils.isItemSelectable(itemInfo) or p1.props.disableInteractions then
			return
		end

		local itemId = tryOnItem.itemId
		local selectedInTryOnManager = tryOnItem.selectedInTryOnManager

		p1.props.setEquippedInTryOnManager(itemId, not selectedInTryOnManager, p1.props.catalogAnalytics, tryOnItem.itemType)

		if p1.props.allowAutomaticPeekViewStateChanges then
			p1.props.setTryOnManagerPeekViewState(PeekViewState.Brief)
		end
	end
end
function v44.getItemIconType(p2) -- line: 139
	-- upvalues: Constants (copy), ItemTileEnums (copy)
	local tryOnItem = p2.props.tryOnItem

	if tryOnItem.itemType == Constants.ItemType.Bundle then
		if tryOnItem.itemSubType == Constants.BundleTypeIdStrings.DynamicHead then
			return ItemTileEnums.ItemIconType.DynamicHead
		end

		return nil
	end

	return tryOnItem.itemType == Constants.ItemType.Bundle and ItemTileEnums.ItemIconType.Bundle or nil
end
function v44.getItemInfo(p3, p4, p5) -- line: 156
	-- upvalues: NumberLocalization (copy)
	local v55 = p4.priceInRobux or nil

	if p3.props.tryOnItem.selectedTimedOptionIndex and p4.timedOptions then
		local v56 = p4.timedOptions[p3.props.tryOnItem.selectedTimedOptionIndex]

		if v56 then
			v55 = v56.price
		end
	end

	local v57 = p4.quantityOwned > 0
	local noPriceStatus = p4.noPriceStatus
	local v59 = false
	local s1 = ""
	local v61 = true
	local offSaleText = nil
	local v63 = nil

	if v57 and not p3.props.forceShowPrice then
		s1 = p5.ownedText
	elseif v55 == 0 then
		s1 = p5.freeText
	elseif v55 ~= nil then
		s1 = NumberLocalization.localize(string.format("%.0f", v55), p3.props.localization:GetLocale())
		v59 = true
	else
		offSaleText = p5.offSaleText
		v61 = false
	end

	if noPriceStatus then
		if noPriceStatus == "OffSale" then
			offSaleText = p5.offSaleText
			v61 = false
		elseif noPriceStatus == "NoResellers" then
			offSaleText = p5.noResellersText
			v61 = false
		elseif noPriceStatus == "InExperience" then
			offSaleText = p5.inExperienceText
		elseif noPriceStatus == "Unavailable" then
			offSaleText = p5.contentDeletedText
			v61 = false
		end
	end

	if v57 and noPriceStatus ~= "Unavailable" then
		v61 = true
	end

	if p4.discountInformation and not v57 then
		local originalPrice = p4.discountInformation.originalPrice

		if p3.props.tryOnItem.selectedTimedOptionIndex and p4.timedOptions then
			local v65 = p4.timedOptions[p3.props.tryOnItem.selectedTimedOptionIndex]

			if v65 and v65.discountInformation then
				originalPrice = v65.discountInformation.originalPrice
			elseif v65 and not v65.discountInformation and v65.days ~= 0 then
				originalPrice = nil
			end
		end

		v63 = if not originalPrice then nil else NumberLocalization.localize(string.format("%.0f", originalPrice), p3.props.localization:GetLocale())
	end

	return s1, v59, offSaleText, v61, v63
end
function v44.renderElement(p6, p7, p8, p9) -- line: 228
	-- upvalues: Constants (copy), getIconRichText (copy), Foundation (copy), CatalogUtils (copy), getRbxthumbWithTypeSizeAndOptions (copy), Utils (copy), Roact (copy), ItemTile (copy), ImageSetLabel (copy), v43 (copy), Colors (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FlexLayout (copy), VerifiedBadges (copy), View (copy), WearTimeSelectedOptionInList (copy), v42 (copy)
	local tryOnItem = p6.props.tryOnItem
	local Theme = p7.Theme
	local p7Font = p7.Font
	local FontSize_350 = p6.props.tokens.FontSize.FontSize_350
	local FontSize_300 = p6.props.tokens.FontSize.FontSize_300
	local v75 = tryOnItem.itemType == Constants.ItemType.Bundle
	local itemInfo = p6.props.itemInfo
	local v77, v78, v79, v80, v81 = p6:getItemInfo(itemInfo, p8)
	local name = itemInfo.name
	local creator = itemInfo.creator
	local itemRestrictionsMap = itemInfo.itemRestrictionsMap
	local v85 = if not v81 then nil else `{ getIconRichText(Foundation.Enums.IconName.Robux) } { v81 }`
	local n1 = 0

	if v75 then
		for _, _ in tryOnItem.bundleInfo do
			n1 += 1
		end
	end

	local v89 = tryOnItem.itemType and CatalogUtils.GetRbxThumbType(tryOnItem.itemType) or nil
	local v90 = nil

	if tryOnItem.itemId and v89 then
		v90 = getRbxthumbWithTypeSizeAndOptions(tryOnItem.itemId, v89, 150)
	end

	local v91 = Utils.isItemSelectable(itemInfo)
	local v92 = p6.props.localization:Format("Feature.Catalog.Label.UsingBundleParts", {
		count = n1
	})
	local Size_1800 = p6.props.tokens.Size.Size_1800
	local XLarge = p6.props.tokens.Padding.XLarge
	local Size_500 = p6.props.tokens.Size.Size_500
	local Size_800 = p6.props.tokens.Size.Size_800
	local v97 = 0 - Size_1800 - XLarge - XLarge + p9

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, XLarge)
		}),
		TryOnManagerTileFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(Size_1800, Size_1800)
		}, {
			TryOnManagerTile = Roact.createElement(ItemTile, {
				titleTextLineCount = 0,
				itemIconType = p6:getItemIconType(),
				restrictionTypes = itemRestrictionsMap,
				Selectable = v91,
				isSelected = if not v91 then nil else tryOnItem.selectedInTryOnManager,
				onActivated = p6.onTileActivated,
				thumbnail = v90
			}),
			TryOnManagerTileAlertFrame = if v91 then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = Theme.Overlay.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10)
				}),
				TryOnManagerTileAlert = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = v43,
					ImageColor3 = Colors.White,
					ImageTransparency = Theme.IconEmphasis.Transparency,
					Size = UDim2.fromOffset(Size_800, Size_800),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			})
		}),
		TryOnInfoFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, v97, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Space_50 else p7.Tokens.Size.Size_100)
			}),
			TopTextRow = Roact.createElement(FlexLayout, {
				flexSlot = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Space_125 else p7.Tokens.Size.Size_250)
					}),
					ItemName = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = FontSize_350,
						Font = p7Font.Header1.Font,
						TextColor3 = p6.props.tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p6.props.tokens.Color.Content.Emphasis.Transparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Text = name
					}),
					VerifiedCreatorName = if not creator or (creator.hasVerifiedBadge ~= true or not creator.name) then nil else Roact.createElement(VerifiedBadges.EmojiWrapper, {
						layoutOrder = 2,
						emoji = VerifiedBadges.emoji.verified,
						font = p7Font.SubHeader1.Font,
						anchorPoint = Vector2.new(1, 0),
						position = UDim2.new(1, 0, 0, 0),
						size = UDim2.new(1, 0, 0, 0),
						automaticSize = Enum.AutomaticSize.Y,
						verticalAlignment = Enum.VerticalAlignment.Center
					}, {
						TextLabel = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Font = p7Font.SubHeader1.Font,
							Size = UDim2.new(0, 0, 1, 0),
							Text = creator.name,
							TextColor3 = p6.props.tokens.Color.Content.Emphasis.Color3,
							TextSize = FontSize_300,
							TextTruncate = Enum.TextTruncate.AtEnd,
							AutomaticSize = Enum.AutomaticSize.XY
						})
					}),
					UnverifiedCreatorName = if not creator or (creator.hasVerifiedBadge == true or not creator.name) then nil else Roact.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.new(1, 0, 0, 0),
						Font = p7Font.SubHeader1.Font,
						TextColor3 = p6.props.tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p6.props.tokens.Color.Content.Emphasis.Transparency,
						TextSize = FontSize_300,
						Text = creator.name,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					HorizontalContainer = Roact.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.new(0, 0, 0, 0)
					}, {
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, p6.props.tokens.Padding.Small),
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						WearTimeOptions = if not p6.props.itemInfo.timedOptions then nil else Roact.createElement(View, {
							tag = "auto-xy",
							LayoutOrder = 1
						}, {
							WearTimeSelectedOptionInList = Roact.createElement(WearTimeSelectedOptionInList, {
								options = p6.props.itemInfo.timedOptions,
								onOptionActivated = function(p10) -- line: 471
									-- upvalues: p6 (copy)
									for i, v in ipairs(p6.props.itemInfo.timedOptions) do
										v.selected = i == p10
									end

									p6.props.setSelectedTimedOption(p6.props.tryOnItem.itemId, p10, p6.props.tryOnItem.itemType)
								end
							})
						}),
						BundleParts = if not (n1 > 0) then nil else Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.XY,
							Transparency = p6.props.tokens.Color.Shift.Shift_200.Transparency,
							BackgroundColor3 = p6.props.tokens.Color.Shift.Shift_200.Color3,
							Size = UDim2.new(0, 0, 0, 0)
						}, {
							UICorner = Roact.createElement("UICorner", {
								CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Size_125 else p7.Tokens.Size.Size_250)
							}),
							UIPadding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, p6.props.tokens.Padding.Small),
								PaddingLeft = UDim.new(0, p6.props.tokens.Padding.Medium),
								PaddingRight = UDim.new(0, p6.props.tokens.Padding.Medium),
								PaddingBottom = UDim.new(0, p6.props.tokens.Padding.Small)
							}),
							BundlePartsText2 = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								AnchorPoint = Vector2.new(0, 0),
								AutomaticSize = Enum.AutomaticSize.XY,
								Position = UDim2.new(0, 0, 0, 0),
								Size = UDim2.new(0, 0, 0, 0),
								Font = p7Font.SubHeader1.Font,
								TextColor3 = p6.props.tokens.Color.Content.Emphasis.Color3,
								TextTransparency = p6.props.tokens.Color.Content.Emphasis.Transparency,
								TextSize = FontSize_300,
								Text = v92,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							})
						})
					}),
					PriceStatusText = if not v79 then nil else Roact.createElement("TextLabel", {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						TextWrapped = true,
						AnchorPoint = Vector2.new(1, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.new(1, 0, 0, 0),
						Font = p7Font.SubHeader1.Font,
						TextColor3 = p6.props.tokens.Color.Content.Muted.Color3,
						TextTransparency = p6.props.tokens.Color.Content.Muted.Transparency,
						TextSize = FontSize_350,
						Text = v79,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				}),
				rigidSlot = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						Padding = UDim.new(0, 6)
					}),
					Icon = v78 and (not not v80 and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Image = v42,
						ImageTransparency = p6.props.tokens.Color.Content.Muted.Transparency,
						ImageColor3 = p6.props.tokens.Color.Content.Muted.Color3,
						Size = UDim2.fromOffset(Size_500, Size_500)
					})) or nil,
					Price = v80 and Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(0, -Size_500 - p9, 0, Size_500),
						Text = v77,
						TextSize = FontSize_350,
						Font = p7Font.Header1.Font,
						TextColor3 = p6.props.tokens.Color.Content.Muted.Color3,
						TextTransparency = p6.props.tokens.Color.Content.Muted.Transparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.X
					}) or nil,
					OriginalPrice = v80 and (not not v85 and Roact.createElement("TextLabel", {
						RichText = true,
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(0, -Size_500 - p9, 0, Size_500),
						Text = "<s>" .. v85 .. "</s>",
						TextSize = FontSize_300,
						Font = p7Font.SubHeader1.Font,
						TextColor3 = p6.props.tokens.Color.Content.Muted.Color3,
						TextTransparency = p6.props.tokens.Color.Content.Muted.Transparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.X
					})) or nil
				})
			})
		})
	})
end
function v44.renderWithProviders(p11, p12, p13) -- line: 612
	-- upvalues: Roact (copy), Focusable (copy)
	local v101 = p11.props.horizontalPadding or 0

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p11.props.layoutOrder,
		ref = p11.props.elementRef,
		NextSelectionDown = p11.props.NextSelectionDown,
		NextSelectionUp = p11.props.NextSelectionUp
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, p11.props.tokens.Padding.Medium)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v101),
			PaddingRight = UDim.new(0, v101)
		}),
		LookDetailsTryOnElement = p11:renderElement(p12, p13, v101)
	})
end
function v44.render(p14) -- line: 642
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p15) -- line: 643
		-- upvalues: withLocalization (copy), p14 (copy)
		return withLocalization({
			noResellersText = "Feature.Catalog.LabelNoResellers",
			inExperienceTest = "Feature.Catalog.Label.InSingleExperience",
			inExperienceText = "Feature.Catalog.Label.InSingleExperience",
			offSaleText = "Feature.Catalog.LabelOffSale",
			freeText = "Feature.Catalog.LabelFree",
			ownedText = "Feature.Catalog.Label.Owned",
			contentDeletedText = "Feature.Catalog.LabelContentDeleted"
		})(function(p16) -- line: 652
			-- upvalues: p14 (copy), p15 (copy)
			return p14:renderWithProviders(p15, p16)
		end)
	end)
end

local function mapStateToProps(p17, _) -- line: 658
	local LocalUserId = p17.LocalUserId

	return {
		playerMembership = p17.Users[LocalUserId] and p17.Users[LocalUserId].membership or Enum.MembershipType.None
	}
end
local function mapDispatchToProps(p19: ((...any) -> ...any)) -- line: 666
	-- upvalues: SetEquippedInTryOnManagerThunk (copy), AvatarScreen (copy), SetTryOnManagerPeekViewState (copy), SetSelectedTimedOption (copy)
	return {
		setEquippedInTryOnManager = function(p20, p21, p22, p23) -- line: 668
			-- upvalues: p19 (copy), SetEquippedInTryOnManagerThunk (copy), AvatarScreen (copy)
			return p19(SetEquippedInTryOnManagerThunk(p20, p21, p22, p23, AvatarScreen.LookDetails))
		end,
		setTryOnManagerPeekViewState = function(p24) -- line: 680
			-- upvalues: p19 (copy), SetTryOnManagerPeekViewState (copy)
			p19(SetTryOnManagerPeekViewState(p24))
		end,
		setSelectedTimedOption = function(p25, p26, p27) -- line: 684
			-- upvalues: p19 (copy), SetSelectedTimedOption (copy)
			p19(SetSelectedTimedOption(p25, p26, p27))
		end
	}
end

local v47 = withNavigation((RoactServices.connect({
	appAnalytics = RoactAnalytics,
	catalogAnalytics = Analytics,
	networking = RoactNetworking,
	localization = RoactLocalization
})(v44)))
local u48 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v47)

return function(p28) -- line: 701
	-- upvalues: useTokens (copy), Roact (copy), u48 (ref), Cryo (copy)
	local v108 = useTokens()

	return Roact.createElement(u48, Cryo.Dictionary.join({
		tokens = v108
	}, p28))
end
