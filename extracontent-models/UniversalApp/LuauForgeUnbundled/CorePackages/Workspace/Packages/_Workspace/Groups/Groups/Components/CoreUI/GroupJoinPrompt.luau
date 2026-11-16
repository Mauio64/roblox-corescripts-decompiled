local TextService = game:GetService("TextService")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/ProfilePlatform/Enums")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UIBlox")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UserLib")
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = UserLib.Utils.Constants
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/VerifiedBadges")

local mouseIconOverrideService = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/CoreScriptsCommon").MouseIconOverrideService
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/CoreScriptsRoactCommon").useScreenSize

local loadableImage = UIBlox.App.Loading.LoadableImage

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

local text = Foundation.Text
local view = Foundation.View
local skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/constants")

local v5 = {
	[Enums.DisabledReasons.BannedFromCommunity] = "subTextBannedFromCommunity",
	[Enums.DisabledReasons.CommunityIsClosed] = "subTextGroupClosed",
	[Enums.DisabledReasons.MaxCommunitiesJoined] = "subTextPremiumMaxGroups",
	[Enums.DisabledReasons.AccountCreatedLessThanOneDay] = "subTextRequiresAccountTenureTooltipOneDay",
	[Enums.DisabledReasons.AccountCreatedLessThanThreeDays] = "subTextRequiresAccountTenureTooltipThreeDays",
	[Enums.DisabledReasons.AccountCreatedLessThanOneWeek] = "subTextRequiresAccountTenureTooltipOneWeek",
	[Enums.DisabledReasons.AccountCreatedLessThanOneMonth] = "subTextRequiresAccountTenureTooltipOneMonth",
	[Enums.DisabledReasons.AccountCreatedLessThanThreeMonths] = "subTextRequiresAccountTenureTooltipThreeMonths",
	[Enums.DisabledReasons.InsufficientVerificationLevelHigh] = "subTextInsufficientVerificationLevelHigh",
	[Enums.DisabledReasons.InsufficientVerificationLevelMedium] = "subTextInsufficientVerificationLevelMedium",
	[Enums.DisabledReasons.InsufficientVerificationLevelLow] = "subTextInsufficientVerificationLevelLow"
}

return function(props)
	local v6 = useTokens()
	local v7 = props.enableInputDelayed == nil or props.enableInputDelayed
	local v8

	if useScreenSize().Y < module8.SMALL_SCREEN_HEIGHT_THRESHOLD then
		v8 = module8.THUMBNAIL_SIZE_SMALL
	else
		v8 = module8.THUMBNAIL_SIZE
	end

	local data = props.data
	local v9 = data == nil
	local groupName = if data then data.groupName else nil
	local ownerName = if data then data.ownerName else nil
	local v10 = if data then data.ownerIsVerified else false
	local v11 = not data and 0 or data.membersCount
	local v12 = if data then data.isAlreadyMember else false
	local v13 = if data then data.hasPendingRequest else false
	local v14 = if data then data.isEligible else false
	local disabledReason = if data then data.disabledReason else nil
	local v15 = not data or data.hasSocialModules == nil or data.hasSocialModules

	local v16 = useLocalization({
		joinGroup = "Feature.Groups.Action.JoinGroup",
		followGroup = "Feature.Groups.Action.Follow",
		notNowButton = "Feature.Groups.Action.NotNow",
		closeButton = "Feature.Groups.Action.Close",
		titleJoin = {
			"Feature.Groups.Title.Join",
			groupName = groupName or ""
		},
		titleFollow = {
			"Feature.Groups.Title.Follow",
			groupName = groupName or ""
		},
		titleAlreadyRequested = {
			"Feature.Groups.Title.RequestedToJoin",
			groupName = groupName or ""
		},
		titleAlreadyMember = {
			"Feature.Groups.Title.AlreadyMember",
			groupName = groupName or ""
		},
		titleAlreadyFollowing = {
			"Feature.Groups.Title.AlreadyFollowing",
			groupName = groupName or ""
		},
		titleUnableToJoin = {
			"Feature.Groups.Title.UnableToJoin",
			groupName = groupName or ""
		},
		ownerBy = {
			"Feature.Groups.Label.ByOwnerWithFormat",
			ownerName = ownerName or ""
		},
		members = "Feature.Groups.Heading.Members",
		followers = "Feature.Groups.Heading.Followers",
		subTextPendingRequest = "Feature.Groups.Description.JoinGroupPending",
		subTextBannedFromCommunity = "Feature.Groups.Message.BannedFromGroup",
		subTextGroupClosed = "Feature.Groups.Message.GroupClosed",
		subTextPremiumMaxGroups = "Feature.Groups.Description.PremiumMaxGroups",
		subTextRequiresAccountTenureTooltipOneDay = "Feature.Groups.Description.RequiresAccountTenureTooltipOneDay",
		subTextRequiresAccountTenureTooltipThreeDays = "Feature.Groups.Description.RequiresAccountTenureTooltipThreeDays",
		subTextRequiresAccountTenureTooltipOneWeek = "Feature.Groups.Description.RequiresAccountTenureTooltipOneWeek",
		subTextRequiresAccountTenureTooltipOneMonth = "Feature.Groups.Description.RequiresAccountTenureTooltipOneMonth",
		subTextRequiresAccountTenureTooltipThreeMonths = "Feature.Groups.Description.RequiresAccountTenureTooltipThreeMonths",
		subTextInsufficientVerificationLevelHigh = "Feature.Groups.Modal.ContentTextHigh",
		subTextInsufficientVerificationLevelMedium = "Feature.Groups.Modal.ContentTextMedium",
		subTextInsufficientVerificationLevelLow = "Feature.Groups.Modal.ContentTextLow",
		subTextNotEligible = "Feature.Groups.Description.NotEligibleToJoin"
	})

	React.useEffect(function()
		mouseIconOverrideService.push("GroupJoinPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function()
			mouseIconOverrideService.pop("GroupJoinPromptOverride")
		end
	end, {})

	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local ref2 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if ref.current then
			local current = ref.current

			if current.AbsoluteSize.X > 0 then
				setState(current.AbsoluteSize.X)
			end

			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if current.AbsoluteSize.X > 0 and current.AbsoluteSize.X ~= state then
					setState(current.AbsoluteSize.X)
				end
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
				absoluteSizeChangedConnection = nil
			end
		end
	end, { state })

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if ref2.current then
			local current = ref2.current

			if current.AbsoluteSize.X > 0 then
				setState2(current.AbsoluteSize.X)
			end

			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if current.AbsoluteSize.X > 0 and current.AbsoluteSize.X ~= state2 then
					setState2(current.AbsoluteSize.X)
				end
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
				absoluteSizeChangedConnection = nil
			end
		end
	end, { state2 })

	local v17 = React.useMemo(function()
		if v13 then
			return v16.subTextPendingRequest
		end

		if v12 or v14 or not disabledReason then
			return nil
		end

		local disabledReason2 = Enums.DisabledReasons[disabledReason]

		local v18 = disabledReason2 and v5[disabledReason2]

		if v18 then
			return v16[v18]
		end

		return v16.subTextNotEligible
	end, { v16, v12, v13, v14, disabledReason })

	local v18 = React.useMemo(function()
		if v9 then
			return nil
		end

		local v19 = if v15 then v16.titleJoin else v16.titleFollow

		if v12 then
			v19 = if v15 then v16.titleAlreadyMember else v16.titleAlreadyFollowing
		elseif v13 then
			v19 = v16.titleAlreadyRequested
		elseif not v14 then
			v19 = v16.titleUnableToJoin
		end

		if v19 then
			return v19
		end

		return groupName
	end, { v16, groupName, v12, v13, v14, v15, v9 })

	local font = v6.Typography.HeadingSmall.Font
	local fontSize = v6.Typography.HeadingSmall.FontSize
	local font2 = v6.Typography.BodyMedium.Font
	local fontSize2 = v6.Typography.BodyMedium.FontSize
	local medium = v6.Padding.Medium

	local v19 = React.useMemo(function()
		if not v18 or v18 == "" or not (state and state > 0) then
			return nil
		end

		if foundationFontFaceMigration then
			return (getTextSize(v18, fontSize, font, Vector2.new(state, 1e999), {
				addTemporaryPadding = false
			}))
		end

		return (TextService:GetTextSize(v18, fontSize, font, Vector2.new(state, 1e999)))
	end, { v18, state, font, fontSize })

	local v20 = React.useMemo(function()
		if v17 and state2 and state2 > 0 then
			local v21 = state2 - medium * 2

			if v21 > 0 then
				if foundationFontFaceMigration then
					return (getTextSize(v17, fontSize2, font2, Vector2.new(v21, 1e999), {
						addTemporaryPadding = false
					}))
				end

				return (TextService:GetTextSize(v17, fontSize2, font2, Vector2.new(v21, 1e999)))
			end
		end

		return nil
	end, { v17, state2, font2, fontSize2, medium })

	local v21 = React.useMemo(function()
		local v22 = {}

		if v19 then
			v22.title = v19
		end

		if v20 then
			v22.subText = v20
		end

		return v22
	end, { v19, v20 })
	local v22

	if props.groupId then
		v22 = getRbxthumbWithTypeSizeAndOptions(
			tostring(props.groupId),
			constants.RbxthumbTypes.GroupIcon,
			module8.THUMBNAIL_SIZE
		)
	else
		v22 = nil
	end

	local v23 = React.useCallback(function()
		if v22 then
			return (React.createElement(
				view,
				{ tag = "col size-full-0 auto-y align-x-center", LayoutOrder = 0 },
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v6.Padding.Medium),
						PaddingBottom = UDim.new(0, v6.Padding.Medium)
					}),
					ImageContainer = React.createElement(view, {
						Size = UDim2.new(0, v8, 0, v8)
					}, {
						UISizeConstraint = React.createElement("UISizeConstraint", {
							MaxSize = Vector2.new(v8, v8)
						}),
						LoadableImage = React.createElement(loadableImage, {
							Size = UDim2.fromScale(1, 1),
							Image = v22,
							BackgroundTransparency = 1,
							useShimmerAnimationWhileLoading = true,
							showFailedStateWhenLoadingFailed = true,
							cornerRadius = UDim.new(0, v6.Radius.Medium)
						})
					})
				}
			))
		end

		return nil
	end, { v22, v6, v8 })

	local v24 = React.useCallback(function()
		local createElement = React.createElement
		local v28

		if v18 and v18 ~= "" and not v9 and v21 and v21.title then
			v28 = React.createElement(text, {
				tag = "text-align-x-left",
				Text = v18,
				TextWrapped = true,
				fontStyle = v6.Typography.HeadingSmall,
				textStyle = v6.Color.Content.Emphasis,
				Size = UDim2.fromOffset(math.ceil(v21.title.X), (math.ceil(v21.title.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not state and 1e999 or state, 1e999)
				})
			})
		elseif v18 and v18 ~= "" and not v9 then
			v28 = React.createElement(text, {
				tag = "size-full-0 auto-y text-align-x-left",
				Text = v18,
				TextWrapped = true,
				fontStyle = v6.Typography.HeadingSmall,
				textStyle = v6.Color.Content.Emphasis
			})
		elseif v9 then
			v28 = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, fontSize)
			})
		end

		return createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1,
			ref = ref
		}, {
			TitleText = v28
		})
	end, { v18, v9, v21, state, v6, ref, fontSize })

	local v25 = React.useCallback(function()
		if ownerName ~= nil and ownerName ~= "" and not v9 then
			return (React.createElement(view, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v6.Padding.XSmall)
				}),
				Content = React.createElement(VerifiedBadges.EmojiWrapper, {
					emoji = not v10 and "" or VerifiedBadges.emoji.verified,
					size = UDim2.new(1, 0, 0, 0),
					automaticSize = Enum.AutomaticSize.Y,
					horizontalAlignment = Enum.HorizontalAlignment.Left
				}, {
					Text = React.createElement(text, {
						tag = "size-full-0 auto-y text-body-medium text-align-x-left",
						Text = v16.ownerBy,
						TextWrapped = true
					})
				})
			}))
		end

		if v9 then
			return (React.createElement(view, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v6.Padding.XSmall)
				}),
				Shimmer = React.createElement(skeleton, {
					Size = UDim2.new(0.6, 0, 0, fontSize2)
				})
			}))
		end

		return nil
	end, { ownerName, v10, v9, v6, v16, fontSize2 })

	local v26 = useAbbreviatedNumberLocalization(v11)

	local v27 = React.useCallback(function()
		local createElement = React.createElement

		local v30 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v6.Padding.Medium)
			}),
			Content = 0
		}
		local v31

		if v9 then
			v31 = React.createElement(skeleton, {
				Size = UDim2.new(0.4, 0, 0, fontSize2)
			})
		elseif v17 == nil or not (v21 and v21.subText) then
			if v17 == nil then
				if v11 and v11 > 0 then
					local createElement2 = React.createElement

					local v36 = if v15 then v16.members else v16.followers
					v31 = createElement2(text, {
						tag = "size-full-0 auto-y text-body-medium text-align-x-left",
						Text = v26 .. " " .. v36,
						TextWrapped = true
					})
				end
			else
				v31 = React.createElement(text, {
					tag = "size-full-0 auto-y text-body-medium text-align-x-left",
					Text = v17,
					TextWrapped = true
				})
			end
		else
			v31 = React.createElement(text, {
				tag = "text-body-medium text-align-x-left",
				Text = v17,
				TextWrapped = true,
				Size = UDim2.fromOffset(math.ceil(v21.subText.X), (math.ceil(v21.subText.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not state2 and 1e999 or state2 - v6.Padding.Medium * 2, 1e999)
				})
			})
		end

		v30.Content = v31
		return createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 3,
			ref = ref2
		}, v30)
	end, {
		v9,
		v17,
		v21,
		state2,
		v6,
		v11,
		v26,
		v15,
		v16,
		ref2,
		fontSize2
	})

	local state3, setState3 = React.useState(false)

	local v28 = React.useCallback(function()
		if not state3 then
			setState3(true)

			if props.onJoin then
				props.onJoin()
			end
		end
	end, { props.onJoin })

	local v29 = React.useCallback(function()
		if not state3 and props.onClose then
			props.onClose()
		end
	end, { props.onClose, state3 })

	local v30 = React.useMemo(function()
		if v9 then
			return {
				{
					variant = buttonVariant.Standard,
					isLoading = true,
					isDisabled = true
				}
			}
		end

		if v12 or not v14 or v13 then
			return {
				{
					variant = buttonVariant.Standard,
					text = v16.closeButton,
					onActivated = v29,
					isDisabled = state3
				}
			}
		end

		local v32 = {
			variant = buttonVariant.Emphasis,
			text = v15 and v16.joinGroup or v16.followGroup,
			onActivated = v28,
			inputDelay = 0,
			isLoading = 0,
			isDisabled = 0
		}

		local v33 = if v7 then module8.ACCEPT_DELAY_SECONDS else nil
		v32.inputDelay = v33
		v32.isLoading = state3
		v32.isDisabled = state3
		return {
			v32,
			{
				variant = buttonVariant.Standard,
				text = v16.notNowButton,
				onActivated = v29,
				isDisabled = state3
			}
		}
	end, {
		v16,
		v28,
		v29,
		v7,
		v13,
		v14,
		v12,
		state3,
		v15
	})

	return React.createElement(dialog.Root, { size = dialogSize.Small, onClose = v29 }, {
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 1 }, {
			Content = React.createElement(view, { tag = "col size-full-0 auto-y" }, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				GroupImage = v23(),
				Title = v24(),
				OwnerName = v25(),
				SubContent = v27()
			})
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 2,
			actions = v30
		})
	})
end
