local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local Enums = require(parent.ProfilePlatform.Enums)

local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Localization = require(parent.Localization)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local VerifiedBadges = require(parent.VerifiedBadges)

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local useScreenSize = CoreScriptsRoactCommon.useScreenSize

local LoadableImage = UIBlox.App.Loading.LoadableImage

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

local Text = Foundation.Text
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

require(Groups.Common.Types)
local constants = require(Groups.Common.constants)

local v = {
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
	local v2 = useTokens()
	local v3 = props.enableInputDelayed == nil or props.enableInputDelayed
	local v4

	if useScreenSize().Y < constants.SMALL_SCREEN_HEIGHT_THRESHOLD then
		v4 = constants.THUMBNAIL_SIZE_SMALL
	else
		v4 = constants.THUMBNAIL_SIZE
	end

	local data = props.data
	local v5 = data == nil
	local groupName

	if data then
		groupName = data.groupName
	else
		groupName = nil
	end

	local ownerName

	if data then
		ownerName = data.ownerName
	else
		ownerName = nil
	end

	local v6

	if data then
		v6 = data.ownerIsVerified
	else
		v6 = false
	end

	local v7 = not data and 0 or data.membersCount
	local v8

	if data then
		v8 = data.isAlreadyMember
	else
		v8 = false
	end

	local v9

	if data then
		v9 = data.hasPendingRequest
	else
		v9 = false
	end

	local v10

	if data then
		v10 = data.isEligible
	else
		v10 = false
	end

	local disabledReason

	if data then
		disabledReason = data.disabledReason
	else
		disabledReason = nil
	end

	local v11 = not data or data.hasSocialModules == nil or data.hasSocialModules

	local v12 = useLocalization({
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
		MouseIconOverrideService.push("GroupJoinPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function()
			MouseIconOverrideService.pop("GroupJoinPromptOverride")
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

	local text = React.useMemo(function()
		if v9 then
			return v12.subTextPendingRequest
		end

		if v8 or v10 or not disabledReason then
			return nil
		end

		local disabledReason2 = Enums.DisabledReasons[disabledReason]

		local v13 = disabledReason2 and v[disabledReason2]

		if v13 then
			return v12[v13]
		end

		return v12.subTextNotEligible
	end, { v12, v8, v9, v10, disabledReason })

	local text2 = React.useMemo(function()
		if v5 then
			return nil
		end

		local v13 = if v11 then v12.titleJoin else v12.titleFollow

		if v8 then
			if v11 then
				v13 = v12.titleAlreadyMember
			else
				v13 = v12.titleAlreadyFollowing
			end
		elseif v9 then
			v13 = v12.titleAlreadyRequested
		elseif not v10 then
			v13 = v12.titleUnableToJoin
		end

		return v13 or groupName
	end, { v12, groupName, v8, v9, v10, v11, v5 })

	local font = v2.Typography.HeadingSmall.Font
	local fontSize = v2.Typography.HeadingSmall.FontSize
	local font2 = v2.Typography.BodyMedium.Font
	local fontSize2 = v2.Typography.BodyMedium.FontSize
	local medium = v2.Padding.Medium

	local title = React.useMemo(function()
		if text2 and text2 ~= "" and state and state > 0 then
			return (GetTextSize(text2, fontSize, font, Vector2.new(state, 1e999), {
				addTemporaryPadding = false
			}))
		end

		return nil
	end, { text2, state, font, fontSize })

	local subText = React.useMemo(function()
		if text and state2 and state2 > 0 then
			local v13 = state2 - medium * 2

			if v13 > 0 then
				return (GetTextSize(text, fontSize2, font2, Vector2.new(v13, 1e999), {
					addTemporaryPadding = false
				}))
			end
		end

		return nil
	end, { text, state2, font2, fontSize2, medium })

	local v13 = React.useMemo(function()
		local v13 = {}

		if title then
			v13.title = title
		end

		if subText then
			v13.subText = subText
		end

		return v13
	end, { title, subText })
	local image

	if props.groupId then
		image = getRbxthumbWithTypeSizeAndOptions(
			tostring(props.groupId),
			Constants.RbxthumbTypes.GroupIcon,
			constants.THUMBNAIL_SIZE
		)
	else
		image = nil
	end

	local v14 = React.useCallback(function()
		if image then
			return (React.createElement(View, {
				tag = "col size-full-0 auto-y align-x-center",
				LayoutOrder = 0
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v2.Padding.Medium),
					PaddingBottom = UDim.new(0, v2.Padding.Medium)
				}),
				ImageContainer = React.createElement(View, { Size = UDim2.new(0, v4, 0, v4) }, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v4, v4)
					}),
					LoadableImage = React.createElement(LoadableImage, {
						Size = UDim2.fromScale(1, 1),
						Image = image,
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						showFailedStateWhenLoadingFailed = true,
						cornerRadius = UDim.new(0, v2.Radius.Medium)
					})
				})
			}))
		end

		return nil
	end, { image, v2, v4 })

	local v15 = React.useCallback(function()
		local createElement = React.createElement
		local titleText

		if text2 and text2 ~= "" and not v5 and v13 and v13.title then
			titleText = React.createElement(Text, {
				tag = "text-align-x-left",
				Text = text2,
				TextWrapped = true,
				fontStyle = v2.Typography.HeadingSmall,
				textStyle = v2.Color.Content.Emphasis,
				Size = UDim2.fromOffset(math.ceil(v13.title.X), (math.ceil(v13.title.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not state and 1e999 or state, 1e999)
				})
			})
		elseif text2 and text2 ~= "" and not v5 then
			titleText = React.createElement(Text, {
				tag = "size-full-0 auto-y text-align-x-left",
				Text = text2,
				TextWrapped = true,
				fontStyle = v2.Typography.HeadingSmall,
				textStyle = v2.Color.Content.Emphasis
			})
		elseif v5 then
			titleText = React.createElement(Skeleton, { Size = UDim2.new(1, 0, 0, fontSize) })
		end

		return createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1, ref = ref }, {
			TitleText = titleText
		})
	end, { text2, v5, v13, state, v2, ref, fontSize })

	local v16 = React.useCallback(function()
		if ownerName ~= nil and ownerName ~= "" and not v5 then
			return (React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v2.Padding.XSmall)
				}),
				Content = React.createElement(VerifiedBadges.EmojiWrapper, {
					emoji = not v6 and "" or VerifiedBadges.emoji.verified,
					size = UDim2.new(1, 0, 0, 0),
					automaticSize = Enum.AutomaticSize.Y,
					horizontalAlignment = Enum.HorizontalAlignment.Left
				}, {
					Text = React.createElement(Text, {
						tag = "size-full-0 auto-y text-body-medium text-align-x-left",
						Text = v12.ownerBy,
						TextWrapped = true
					})
				})
			}))
		end

		if v5 then
			return (React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v2.Padding.XSmall)
				}),
				Shimmer = React.createElement(Skeleton, {
					Size = UDim2.new(0.6, 0, 0, fontSize2)
				})
			}))
		end

		return nil
	end, { ownerName, v6, v5, v2, v12, fontSize2 })

	local v17 = useAbbreviatedNumberLocalization(v7)

	local v18 = React.useCallback(function()
		local createElement = React.createElement

		local v18 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v2.Padding.Medium)
			}),
			Content = 0
		}
		local content

		if v5 then
			content = React.createElement(Skeleton, {
				Size = UDim2.new(0.4, 0, 0, fontSize2)
			})
		elseif text == nil or not (v13 and v13.subText) then
			if text == nil then
				if v7 and v7 > 0 then
					local createElement2 = React.createElement
					local v19

					if v11 then
						v19 = v12.members
					else
						v19 = v12.followers
					end

					content = createElement2(Text, {
						tag = "size-full-0 auto-y text-body-medium text-align-x-left",
						Text = v17 .. " " .. v19,
						TextWrapped = true
					})
				end
			else
				content = React.createElement(Text, {
					tag = "size-full-0 auto-y text-body-medium text-align-x-left",
					Text = text,
					TextWrapped = true
				})
			end
		else
			content = React.createElement(Text, {
				tag = "text-body-medium text-align-x-left",
				Text = text,
				TextWrapped = true,
				Size = UDim2.fromOffset(math.ceil(v13.subText.X), (math.ceil(v13.subText.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not state2 and 1e999 or state2 - v2.Padding.Medium * 2, 1e999)
				})
			})
		end

		v18.Content = content
		return createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 3, ref = ref2 }, v18)
	end, {
		v5,
		text,
		v13,
		state2,
		v2,
		v7,
		v17,
		v11,
		v12,
		ref2,
		fontSize2
	})

	local state3, setState3 = React.useState(false)

	local onActivated = React.useCallback(function()
		if not state3 then
			setState3(true)

			if props.onJoin then
				props.onJoin()
			end
		end
	end, { props.onJoin })

	local v19 = React.useCallback(function()
		if not state3 and props.onClose then
			props.onClose()
		end
	end, { props.onClose, state3 })

	local actions = React.useMemo(function()
		if v5 then
			return {
				{ variant = ButtonVariant.Standard, isLoading = true, isDisabled = true }
			}
		end

		if v8 or not v10 or v9 then
			return {
				{
					variant = ButtonVariant.Standard,
					text = v12.closeButton,
					onActivated = v19,
					isDisabled = state3
				}
			}
		end

		local v20 = {
			variant = ButtonVariant.Emphasis,
			text = v11 and v12.joinGroup or v12.followGroup,
			onActivated = onActivated,
			inputDelay = 0,
			isLoading = 0,
			isDisabled = 0
		}
		local inputDelay

		if v3 then
			inputDelay = constants.ACCEPT_DELAY_SECONDS
		end

		v20.inputDelay = inputDelay
		v20.isLoading = state3
		v20.isDisabled = state3
		return {
			v20,
			{
				variant = ButtonVariant.Standard,
				text = v12.notNowButton,
				onActivated = v19,
				isDisabled = state3
			}
		}
	end, {
		v12,
		onActivated,
		v19,
		v3,
		v9,
		v10,
		v8,
		state3,
		v11
	})

	return React.createElement(Dialog.Root, { size = DialogSize.Small, onClose = v19 }, {
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 1 }, {
			Content = React.createElement(View, { tag = "col size-full-0 auto-y" }, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				GroupImage = v14(),
				Title = v15(),
				OwnerName = v16(),
				SubContent = v18()
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, { LayoutOrder = 2, actions = actions })
	})
end
