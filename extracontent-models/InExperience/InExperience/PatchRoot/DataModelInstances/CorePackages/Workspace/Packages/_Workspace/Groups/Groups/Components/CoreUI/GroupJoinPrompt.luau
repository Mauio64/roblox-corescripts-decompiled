local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local TextService = game:GetService("TextService")
local Enums = require(GroupsParent.ProfilePlatform.Enums)
local Foundation = require(GroupsParent.Foundation)
local Localization = require(GroupsParent.Localization)
local React = require(GroupsParent.React)
local UIBlox = require(GroupsParent.UIBlox)
local UserLib = require(GroupsParent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local VerifiedBadges = require(GroupsParent.VerifiedBadges)
local MouseIconOverrideService = require(GroupsParent.CoreScriptsCommon).MouseIconOverrideService
local useScreenSize = require(GroupsParent.CoreScriptsRoactCommon).useScreenSize
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local FoundationText = Foundation.Text
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

require(Groups.Common.Types)

local constants = require(Groups.Common.constants)
local t1 = {
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

return function(t2: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), useScreenSize (copy), constants (copy), useLocalization (copy), React (copy), MouseIconOverrideService (copy), Enums (copy), t1 (copy), TextService (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), View (copy), LoadableImage (copy), FoundationText (copy), Skeleton (copy), VerifiedBadges (copy), useAbbreviatedNumberLocalization (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy)
	local v28 = useTokens()
	local v29 = t2.enableInputDelayed == nil or t2.enableInputDelayed
	local v30 = if not (useScreenSize().Y < constants.SMALL_SCREEN_HEIGHT_THRESHOLD) then constants.THUMBNAIL_SIZE else constants.THUMBNAIL_SIZE_SMALL
	local data = t2.data
	local v32 = data == nil
	local v33 = if not data then nil else data.groupName
	local v34 = if not data then nil else data.ownerName
	local v35 = not not data and data.ownerIsVerified
	local v36 = not data and 0 or data.membersCount
	local v37 = not not data and data.isAlreadyMember
	local v38 = not not data and data.hasPendingRequest
	local v39 = not not data and data.isEligible
	local v40 = if not data then nil else data.disabledReason
	local v41 = not data or (data.hasSocialModules == nil or data.hasSocialModules)
	local v42 = useLocalization({
		joinGroup = "Feature.Groups.Action.JoinGroup",
		followGroup = "Feature.Groups.Action.Follow",
		notNowButton = "Feature.Groups.Action.NotNow",
		closeButton = "Feature.Groups.Action.Close",
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
		subTextNotEligible = "Feature.Groups.Description.NotEligibleToJoin",
		titleJoin = {
			"Feature.Groups.Title.Join",
			groupName = v33 or ""
		},
		titleFollow = {
			"Feature.Groups.Title.Follow",
			groupName = v33 or ""
		},
		titleAlreadyRequested = {
			"Feature.Groups.Title.RequestedToJoin",
			groupName = v33 or ""
		},
		titleAlreadyMember = {
			"Feature.Groups.Title.AlreadyMember",
			groupName = v33 or ""
		},
		titleAlreadyFollowing = {
			"Feature.Groups.Title.AlreadyFollowing",
			groupName = v33 or ""
		},
		titleUnableToJoin = {
			"Feature.Groups.Title.UnableToJoin",
			groupName = v33 or ""
		},
		ownerBy = {
			"Feature.Groups.Label.ByOwnerWithFormat",
			ownerName = v34 or ""
		}
	})

	React.useEffect(function() -- line: 124
		-- upvalues: MouseIconOverrideService (copy)
		MouseIconOverrideService.push("GroupJoinPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function() -- line: 127
			-- upvalues: MouseIconOverrideService (copy)
			MouseIconOverrideService.pop("GroupJoinPromptOverride")
		end
	end, {})

	local v43 = React.useRef(nil)
	local v44, v45 = React.useState(nil)
	local v46 = React.useRef(nil)
	local v47, v48 = React.useState(nil)

	React.useEffect(function() -- line: 138
		-- upvalues: v43 (copy), v45 (copy), v44 (copy)
		local connection = nil

		if v43.current then
			local current = v43.current

			if current.AbsoluteSize.X > 0 then
				v45(current.AbsoluteSize.X)
			end

			connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 145
				-- upvalues: current (copy), v44 (copy), v45 (copy)
				if current.AbsoluteSize.X > 0 and current.AbsoluteSize.X ~= v44 then
					v45(current.AbsoluteSize.X)
				end
			end)
		end

		return function() -- line: 151
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { v44 })
	React.useEffect(function() -- line: 159
		-- upvalues: v46 (copy), v48 (copy), v47 (copy)
		local connection = nil

		if v46.current then
			local current = v46.current

			if current.AbsoluteSize.X > 0 then
				v48(current.AbsoluteSize.X)
			end

			connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 166
				-- upvalues: current (copy), v47 (copy), v48 (copy)
				if current.AbsoluteSize.X > 0 and current.AbsoluteSize.X ~= v47 then
					v48(current.AbsoluteSize.X)
				end
			end)
		end

		return function() -- line: 172
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { v47 })

	local v49 = React.useMemo(function() -- line: 180
		-- upvalues: v38 (copy), v42 (copy), v37 (copy), v39 (copy), v40 (copy), Enums (copy), t1 (copy)
		if v38 then
			return v42.subTextPendingRequest
		end

		if not v37 and not v39 and v40 then
			local v74 = Enums.DisabledReasons[v40]

			if v74 then
				local v75 = t1[v74]

				if v75 then
					return v42[v75]
				end
			end

			return v42.subTextNotEligible
		end

		return nil
	end, {
		v42,
		v37,
		v38,
		v39,
		v40
	})
	local v50 = React.useMemo(function() -- line: 201
		-- upvalues: v32 (copy), v41 (copy), v42 (copy), v37 (copy), v38 (copy), v39 (copy), v33 (copy)
		if v32 then
			return nil
		end

		local v76 = if not v41 then v42.titleFollow else v42.titleJoin

		if v37 then
			v76 = if not v41 then v42.titleAlreadyFollowing else v42.titleAlreadyMember
		elseif v38 then
			v76 = v42.titleAlreadyRequested
		elseif not v39 then
			v76 = v42.titleUnableToJoin
		end

		if v76 then
			return v76
		end

		return v33
	end, {
		v42,
		v33,
		v37,
		v38,
		v39,
		v41,
		v32
	})
	local HeadingSmallFont = v28.Typography.HeadingSmall.Font
	local FontSize = v28.Typography.HeadingSmall.FontSize
	local BodyMediumFont = v28.Typography.BodyMedium.Font
	local FontSize2 = v28.Typography.BodyMedium.FontSize
	local Medium = v28.Padding.Medium
	local v56 = React.useMemo(function() -- line: 230
		-- upvalues: v50 (copy), v44 (copy), TextService (copy), FontSize (copy), HeadingSmallFont (copy)
		if v50 and (v50 ~= "" and v44 and v44 > 0) then
			return (TextService:GetTextSize(v50, FontSize, HeadingSmallFont, Vector2.new(v44, 1e999)))
		end

		return nil
	end, {
		v50,
		v44,
		HeadingSmallFont,
		FontSize
	})
	local v57 = React.useMemo(function() -- line: 244
		-- upvalues: v49 (copy), v47 (copy), Medium (copy), TextService (copy), FontSize2 (copy), BodyMediumFont (copy)
		if v49 and (v47 and v47 > 0) then
			local v77 = v47 - Medium * 2

			if v77 > 0 then
				return (TextService:GetTextSize(v49, FontSize2, BodyMediumFont, Vector2.new(v77, 1e999)))
			end
		end

		return nil
	end, {
		v49,
		v47,
		BodyMediumFont,
		FontSize2,
		Medium
	})
	local v58 = React.useMemo(function() -- line: 261
		-- upvalues: v56 (copy), v57 (copy)
		local t3 = {}

		if v56 then
			t3.title = v56
		end

		if v57 then
			t3.subText = v57
		end

		return t3
	end, {
		v56,
		v57
	})
	local v59 = if not t2.groupId then nil else getRbxthumbWithTypeSizeAndOptions(tostring(t2.groupId), Constants.RbxthumbTypes.GroupIcon, constants.THUMBNAIL_SIZE)
	local v60 = React.useCallback(function() -- line: 281
		-- upvalues: v59 (copy), React (copy), View (copy), v28 (copy), v30 (copy), LoadableImage (copy)
		if v59 then
			return (React.createElement(View, {
				tag = "col size-full-0 auto-y align-x-center",
				LayoutOrder = 0
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v28.Padding.Medium),
					PaddingBottom = UDim.new(0, v28.Padding.Medium)
				}),
				ImageContainer = React.createElement(View, {
					Size = UDim2.new(0, v30, 0, v30)
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v30, v30)
					}),
					LoadableImage = React.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						showFailedStateWhenLoadingFailed = true,
						Size = UDim2.fromScale(1, 1),
						Image = v59,
						cornerRadius = UDim.new(0, v28.Radius.Medium)
					})
				})
			}))
		end

		return nil
	end, {
		v59,
		v28,
		v30
	})
	local v61 = React.useCallback(function() -- line: 310
		-- upvalues: React (copy), View (copy), v43 (copy), v50 (copy), v32 (copy), v58 (copy), FoundationText (copy), v28 (copy), v44 (copy), Skeleton (copy), FontSize (copy)
		return React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1,
			ref = v43
		}, {
			TitleText = if not v50 or (v50 == "" or (v32 or (not v58 or not v58.title))) then if not v50 or (v50 == "" or v32) then if not v32 then nil else React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, FontSize)
			}) else React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-align-x-left",
				TextWrapped = true,
				Text = v50,
				fontStyle = v28.Typography.HeadingSmall,
				textStyle = v28.Color.Content.Emphasis
			}) else React.createElement(FoundationText, {
				tag = "text-align-x-left",
				TextWrapped = true,
				Text = v50,
				fontStyle = v28.Typography.HeadingSmall,
				textStyle = v28.Color.Content.Emphasis,
				Size = UDim2.fromOffset(math.ceil(v58.title.X), (math.ceil(v58.title.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not v44 and 1e999 or v44, 1e999)
				})
			})
		})
	end, {
		v50,
		v32,
		v58,
		v44,
		v28,
		v43,
		FontSize
	})
	local v62 = React.useCallback(function() -- line: 348
		-- upvalues: v34 (copy), v32 (copy), React (copy), View (copy), v28 (copy), VerifiedBadges (copy), v35 (copy), FoundationText (copy), v42 (copy), Skeleton (copy), FontSize2 (copy)
		if v34 ~= nil and (v34 ~= "" and not v32) then
			return (React.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v28.Padding.XSmall)
				}),
				Content = React.createElement(VerifiedBadges.EmojiWrapper, {
					emoji = not v35 and "" or VerifiedBadges.emoji.verified,
					size = UDim2.new(1, 0, 0, 0),
					automaticSize = Enum.AutomaticSize.Y,
					horizontalAlignment = Enum.HorizontalAlignment.Left
				}, {
					Text = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-body-medium text-align-x-left",
						TextWrapped = true,
						Text = v42.ownerBy
					})
				})
			}))
		end

		if v32 then
			return (React.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v28.Padding.XSmall)
				}),
				Shimmer = React.createElement(Skeleton, {
					Size = UDim2.new(0.6, 0, 0, FontSize2)
				})
			}))
		end

		return nil
	end, {
		v34,
		v35,
		v32,
		v28,
		v42,
		FontSize2
	})
	local v63 = useAbbreviatedNumberLocalization(v36)
	local v64 = React.useCallback(function() -- line: 389
		-- upvalues: React (copy), View (copy), v46 (copy), v28 (copy), v32 (copy), Skeleton (copy), FontSize2 (copy), v49 (copy), v58 (copy), FoundationText (copy), v47 (copy), v36 (copy), v63 (copy), v41 (copy), v42 (copy)
		return React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 3,
			ref = v46
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v28.Padding.Medium)
			}),
			Content = if not v32 then if v49 == nil or (not v58 or not v58.subText) then if v49 == nil then if not v36 or not (v36 > 0) then nil else React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-align-x-left",
				TextWrapped = true,
				Text = v63 .. " " .. if not v41 then v42.followers else v42.members
			}) else React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-align-x-left",
				TextWrapped = true,
				Text = v49
			}) else React.createElement(FoundationText, {
				tag = "text-body-medium text-align-x-left",
				TextWrapped = true,
				Text = v49,
				Size = UDim2.fromOffset(math.ceil(v58.subText.X), (math.ceil(v58.subText.Y))),
				AutomaticSize = Enum.AutomaticSize.None
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(not v47 and 1e999 or v47 - v28.Padding.Medium * 2, 1e999)
				})
			}) else React.createElement(Skeleton, {
				Size = UDim2.new(0.4, 0, 0, FontSize2)
			})
		})
	end, {
		v32,
		v49,
		v58,
		v47,
		v28,
		v36,
		v63,
		v41,
		v42,
		v46,
		FontSize2
	})
	local v65, v66 = React.useState(false)
	local v67 = React.useCallback(function() -- line: 450
		-- upvalues: v65 (copy), v66 (copy), t2 (copy)
		if not v65 then
			v66(true)

			if t2.onJoin then
				t2.onJoin()
			end
		end
	end, { t2.onJoin })
	local v68 = React.useCallback(function() -- line: 459
		-- upvalues: v65 (copy), t2 (copy)
		if not v65 and t2.onClose then
			t2.onClose()
		end
	end, {
		t2.onClose,
		v65
	})
	local v69 = React.useMemo(function() -- line: 467
		-- upvalues: v32 (copy), ButtonVariant (copy), v37 (copy), v39 (copy), v38 (copy), v42 (copy), v68 (copy), v65 (copy), v41 (copy), v67 (copy), v29 (copy), constants (copy)
		if v32 then
			return {{
				isLoading = true,
				isDisabled = true,
				variant = ButtonVariant.Standard
			}}
		end

		if v37 or not v39 or v38 then
			return {{
				variant = ButtonVariant.Standard,
				text = v42.closeButton,
				onActivated = v68,
				isDisabled = v65
			}}
		end

		return {
			{
				variant = ButtonVariant.Emphasis,
				text = v41 and v42.joinGroup or v42.followGroup,
				onActivated = v67,
				inputDelay = if not v29 then nil else constants.ACCEPT_DELAY_SECONDS,
				isLoading = v65,
				isDisabled = v65
			},
			{
				variant = ButtonVariant.Standard,
				text = v42.notNowButton,
				onActivated = v68,
				isDisabled = v65
			}
		}
	end, {
		v42,
		v67,
		v68,
		v29,
		v38,
		v39,
		v37,
		v65,
		v41
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		onClose = v68
	}, {
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 1
		}, {
			Content = React.createElement(View, {
				tag = "col size-full-0 auto-y"
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				GroupImage = v60(),
				Title = v61(),
				OwnerName = v62(),
				SubContent = v64()
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			actions = v69
		})
	})
end
