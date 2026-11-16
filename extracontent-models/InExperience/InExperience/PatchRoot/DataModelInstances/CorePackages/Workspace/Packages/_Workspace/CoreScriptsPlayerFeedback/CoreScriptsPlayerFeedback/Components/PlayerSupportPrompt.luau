local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local Button = Foundation.Button
local Checkbox = Foundation.Checkbox
local Dropdown = Foundation.Dropdown
local Icon = Foundation.Icon
local TextArea = Foundation.TextArea
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local InputVariant = Foundation.Enums.InputVariant
local useTokens = Foundation.Hooks.useTokens

local BuilderIcons = require(parent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local constants = require(CoreScriptsPlayerFeedback.constants)
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local FFlagPlayerSupportPromptEventIngest = require(CoreScriptsPlayerFeedback.Flags.FFlagPlayerSupportPromptEventIngest)
local PlayerSupportPromptTelemetry = require(CoreScriptsPlayerFeedback.Telemetry.PlayerSupportPromptTelemetry)
local FFlagEnablePlayerSupportCaptureAttachments = require(CoreScriptsPlayerFeedback.Flags.FFlagEnablePlayerSupportCaptureAttachments)
local FFlagEnablePlayerSupportSuggestionCategory = require(CoreScriptsPlayerFeedback.Flags.FFlagEnablePlayerSupportSuggestionCategory)
require(CoreScriptsPlayerFeedback.CaptureTypes)
local useCaptureUploads = require(CoreScriptsPlayerFeedback.Hooks.useCaptureUploads)
local useGalleryCaptures = require(CoreScriptsPlayerFeedback.Hooks.useGalleryCaptures)
local CapturePreviewTile = require(CoreScriptsPlayerFeedback.Components.CapturePreviewTile)
local CapturePickerGrid = require(CoreScriptsPlayerFeedback.Components.CapturePickerGrid)
local CapturePickerPreview = require(CoreScriptsPlayerFeedback.Components.CapturePickerPreview)
local getCaptureKey = require(CoreScriptsPlayerFeedback.Utils.getCaptureKey)

local memo = React.memo(function(props)
	local v = useTokens()
	local count = 0

	for _ in props.uploadStatuses do
		count += 1
	end

	local v2 = count > 0
	local v3 = useLocalization({
		CapturesHeading = {
			"CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Heading",
			count = tostring(count),
			max = tostring(props.maxSelections)
		},
		CapturesAdd = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Add",
		CapturesHint = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Hint",
		CapturesEditSelection = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.EditSelection",
		CapturesUploadError = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.UploadError"
	})

	local children = {
		UIGridLayout = React.createElement("UIGridLayout", {
			CellPadding = UDim2.new(0, 6, 0, 6),
			CellSize = UDim2.new(0, 80, 0, 80),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2)
		})
	}

	local v4 = {}

	for k, uploadStatus in props.uploadStatuses do
		table.insert(v4, { key = k, captureStatus = uploadStatus })
	end

	table.sort(v4, function(a, b): boolean
		return (a.captureStatus.order or 0) < (b.captureStatus.order or 0)
	end)
	local count2 = 0

	for _, v5 in v4 do
		count2 += 1
		local key = v5.key
		children[v5.key] = React.createElement(CapturePreviewTile, {
			capture = v5.captureStatus.capture,
			status = v5.captureStatus.status,
			failureReason = v5.captureStatus.failureReason,
			layoutOrder = count2,
			onRemove = function()
				props.onCaptureRemoved(key)
			end
		})
	end

	if v2 then
		children.EditSelectionButton = React.createElement("ImageButton", {
			BackgroundColor3 = v.Color.Surface.Surface_300.Color3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Image = "",
			LayoutOrder = count2 + 1,
			Size = UDim2.new(0, 80, 0, 80),
			[React.Event.Activated] = props.onPickerOpen
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ImageIcon = React.createElement(Icon, {
				name = BuilderIcons.Icon.Image,
				size = IconSize.Medium,
				variant = IconVariant.Filled,
				style = { Color3 = v.Color.Content.Muted.Color3 },
				LayoutOrder = 1
			}),
			Label = React.createElement(Text, {
				Text = v3.CapturesEditSelection,
				tag = "auto-xy text-caption-small text-wrap content-muted",
				LayoutOrder = 2
			})
		})
	end

	local flag = false

	for _, uploadStatus in props.uploadStatuses do
		if
			uploadStatus.status == "failed"
			and uploadStatus.failureReason ~= Enum.UploadCaptureResult.CaptureModerated
		then
			flag = true
		end
	end

	local createElement = React.createElement
	local v5 = {
		tag = "col gap-small size-full-0 auto-y",
		GroupTransparency = props.category == "" and 0.75 or 0,
		LayoutOrder = 3,
		padding = { top = UDim.new(0, 4), bottom = UDim.new(0, 4) }
	}
	local heading

	if v2 then
		heading = React.createElement(Text, {
			Text = v3.CapturesHeading,
			tag = "size-0 auto-xy text-title-medium text-wrap text-align-x-left text-align-y-top",
			textStyle = v.Color.Content.Emphasis,
			LayoutOrder = 1
		})
	end

	local previewGrid

	if v2 then
		previewGrid = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0)
			},
			children
		)
	end

	local errorHint

	if flag then
		errorHint = React.createElement(Text, {
			Text = v3.CapturesUploadError,
			tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left content-alert",
			LayoutOrder = 3
		})
	end

	local emptyRow

	if not v2 then
		emptyRow = React.createElement(
			View,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 2 },
			{
				AddButton = React.createElement(Button, {
					text = v3.CapturesAdd,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					onActivated = props.onPickerOpen,
					isDisabled = props.category == "",
					LayoutOrder = 1
				}),
				Hint = React.createElement(Text, {
					Text = v3.CapturesHint,
					tag = "fill size-full-0 text-body-medium text-wrap text-align-x-left content-muted",
					LayoutOrder = 2
				})
			}
		)
	end

	return createElement(View, v5, {
		Heading = heading,
		PreviewGrid = previewGrid,
		ErrorHint = errorHint,
		EmptyRow = emptyRow
	})
end)

local PLAYER_SUPPORT_CATEGORIES_REQUIRING_USER_ID = constants.PLAYER_SUPPORT_CATEGORIES_REQUIRING_USER_ID

return (React.memo(function(props)
	local v = useTokens()
	local description = props.description
	local setDescription = props.setDescription
	local category = props.category
	local setCategory = props.setCategory
	local shareUserId = props.shareUserId
	local setShareUserId = props.setShareUserId
	local v2, v3, state, setState, state2, setState2, state3, setState3

	if FFlagEnablePlayerSupportCaptureAttachments then
		v2 = useCaptureUploads()
		v3 = useGalleryCaptures()
		state, setState = React.useState(false)
		state2, setState2 = React.useState({})
		state3, setState3 = React.useState(nil)
	else
		setState = nil
		state = nil
		setState2 = nil
		setState3 = nil
		v2 = nil
		v3 = nil
		state2 = nil
		state3 = nil
	end

	local MIN_FEEDBACK_LENGTH = constants.MIN_FEEDBACK_LENGTH
	local MAX_PLAYER_SUPPORT_LENGTH = constants.MAX_PLAYER_SUPPORT_LENGTH

	local v4 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Title",
		ReportAbuseLead = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Lead",
		ReportAbuseLink = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Link",
		CategoryLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Label",
		CategoryPlaceholder = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Placeholder",
		CategoryItemBugReport = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.BugReport",
		CategoryItemDataRestoreRequest = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.DataRestoreRequest",
		CategoryItemPurchasingIssue = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.PurchasingIssue",
		CategoryItemSuggestion = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Suggestion",
		CategoryItemOther = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Other",
		DescriptionLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Description.Label",
		DescriptionPlaceholderBugReport = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.BugReport",
		DescriptionPlaceholderDataRestoreRequest = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.DataRestoreRequest",
		DescriptionPlaceholderPurchasingIssue = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.PurchasingIssue",
		DescriptionPlaceholderSuggestion = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.Suggestion",
		DescriptionPlaceholderOther = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.Other",
		DescriptionHint = {
			"CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Description.CharacterLimitHint",
			MAX = tostring(MAX_PLAYER_SUPPORT_LENGTH)
		},
		ShareUserIdLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.Label",
		ShareUserIdLabelRequired = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.LabelRequired",
		ShareUserIdHint = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.Hint",
		Send = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Send",
		Add = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Add",
		Cancel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Cancel",
		Select = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Select",
		Deselect = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Deselect",
		CapturesAdd = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Add"
	})

	local items = {
		{ id = "TICKET_CATEGORY_BUG_REPORT", text = v4.CategoryItemBugReport },
		{ id = "TICKET_CATEGORY_DATA_RESTORE_REQUEST", text = v4.CategoryItemDataRestoreRequest },
		{ id = "TICKET_CATEGORY_PURCHASING_ISSUE", text = v4.CategoryItemPurchasingIssue }
	}

	if FFlagEnablePlayerSupportSuggestionCategory then
		table.insert(items, { id = "TICKET_CATEGORY_SUGGESTION", text = v4.CategoryItemSuggestion })
	end

	table.insert(items, { id = "TICKET_CATEGORY_OTHER", text = v4.CategoryItemOther })

	local v5 = {
		["TICKET_CATEGORY_BUG_REPORT"] = v4.DescriptionPlaceholderBugReport,
		TICKET_CATEGORY_DATA_RESTORE_REQUEST = v4.DescriptionPlaceholderDataRestoreRequest,
		TICKET_CATEGORY_PURCHASING_ISSUE = v4.DescriptionPlaceholderPurchasingIssue,
		TICKET_CATEGORY_OTHER = v4.DescriptionPlaceholderOther
	}

	if FFlagEnablePlayerSupportSuggestionCategory then
		v5.TICKET_CATEGORY_SUGGESTION = v4.DescriptionPlaceholderSuggestion
	end

	local v6 = PLAYER_SUPPORT_CATEGORIES_REQUIRING_USER_ID[category] == true
	local v7 = v6 or shareUserId
	local onPickerOpen, v8, v9, onToggle, fn

	if FFlagEnablePlayerSupportCaptureAttachments then
		onPickerOpen = React.useCallback(function()
			if category == "" then
				return
			end

			setState(true)
		end, { category })

		React.useEffect(function()
			if state then
				local set = {}

				for k in v2.uploadStatuses do
					set[k] = true
				end

				setState2(set)
				setState3(nil)
				v3.load()
			else
				setState2({})
				setState3(nil)
			end
		end, { state })

		local v10 = React.useMemo(function()
			local captures = {}

			for _, capture in v3.captures do
				if state2[getCaptureKey(capture)] then
					table.insert(captures, capture)
				end
			end

			return captures
		end, { v3.captures, state2 })

		v8 = #v10
		v9 = v8 >= 5
		onToggle = React.useCallback(function(p)
			local captureKey = getCaptureKey(p)
			setState2(function(p2)
				local v11 = p2[captureKey] == true

				if not v11 and v9 then
					return p2
				end

				local clone = table.clone(p2)

				if v11 then
					clone[captureKey] = nil
					return clone
				end

				clone[captureKey] = true

				return clone
			end)
		end, { v9 })

		local v11 = next(v2.uploadStatuses) ~= nil
		fn = function()
			if v8 == 0 and not v11 then
				return
			end

			v2.onCapturesAdded(v10)
			setState(false)
		end
	else
		onToggle = nil
		v8 = 0
		v9 = false
	end

	local v10

	if FFlagEnablePlayerSupportCaptureAttachments then
		local captureTime

		if state3 then
			captureTime = state3.CaptureTime
		end

		local LocalizationService = game:GetService("LocalizationService")
		local robloxLocaleId = LocalizationService.RobloxLocaleId
		v10 = useLocalization({
			dateTime = {
				"CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Captures.Picker.DateTime",
				date = not captureTime and "" or captureTime:FormatLocalTime("L", robloxLocaleId),
				time = not captureTime and "" or captureTime:FormatLocalTime("LT", robloxLocaleId)
			}
		})
	end

	local v11

	if MIN_FEEDBACK_LENGTH <= #description and #description <= MAX_PLAYER_SUPPORT_LENGTH and category ~= "" then
		v11 = not (v2 and v2.anyUploading or v2 and v2.hasNonModerationFailure)
	else
		v11 = false
	end

	if FFlagPlayerSupportPromptEventIngest then
		React.useEffect(function()
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.Opened,
				category = category,
				shareUserId = v7,
				descriptionLength = #description
			})
		end, {})
	end

	local useCallback = React.useCallback
	local function fn2()
		if not v11 then
			return
		end

		if FFlagPlayerSupportPromptEventIngest then
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.Submitted,
				category = category,
				shareUserId = v7,
				shareUserIdRequired = v6,
				descriptionLength = #description
			})
		end

		pcall(function()
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionCompleted then
				local v12 = {
					Description = description,
					Category = category,
					ShareUserIdPreference = v7 and "SHARE_USER_ID_PREFERENCE_SHARE" or "SHARE_USER_ID_PREFERENCE_DO_NOT_SHARE"
				}

				if FFlagEnablePlayerSupportCaptureAttachments then
					local assetIds = {}

					for _, uploadStatus in v2.uploadStatuses do
						if uploadStatus.status == "succeeded" and uploadStatus.assetId ~= nil then
							table.insert(assetIds, uploadStatus.assetId)
						end
					end

					if #assetIds > 0 then
						v12.AssetIds = assetIds
					end
				end

				SocialService:SignalFeedbackSubmissionCompleted("", v12)
			end
		end)
		props.closePrompt()
	end

	local v12

	if FFlagPlayerSupportPromptEventIngest then
		v12 = {
			description,
			category,
			v7,
			v6,
			v11,
			v2 or false,
			props.closePrompt
		}
	else
		v12 = {
			description,
			category,
			v7,
			v11,
			v2 or false,
			props.closePrompt
		}
	end

	local onActivated = useCallback(fn2, v12)

	local v13 = React.useCallback(function()
		pcall(function()
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		props.onFormAbandoned()
		props.closePrompt()
	end, { props.closePrompt, props.onFormAbandoned })
	local onClose

	if FFlagPlayerSupportPromptEventIngest then
		onClose = React.useCallback(function()
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.Dismissed,
				dismissMethod = PlayerSupportPromptTelemetry.DismissMethod.DialogClose,
				category = category,
				shareUserId = v7,
				descriptionLength = #description
			})

			v13()
		end, { v13, category, v7, description })
	else
		onClose = v13
	end

	local v14

	if FFlagPlayerSupportPromptEventIngest then
		v14 = React.useCallback(function()
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.Dismissed,
				dismissMethod = PlayerSupportPromptTelemetry.DismissMethod.Escape,
				category = category,
				shareUserId = v7,
				descriptionLength = #description
			})

			v13()
		end, { v13, category, v7, description })
	else
		v14 = v13
	end

	local useCallback2 = React.useCallback
	local function fn3()
		if FFlagPlayerSupportPromptEventIngest then
			PlayerSupportPromptTelemetry.log({
				action = PlayerSupportPromptTelemetry.Action.ReportAbuseClicked,
				category = category,
				shareUserId = v7,
				descriptionLength = #description
			})
		end

		pcall(function()
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		props.onFormAbandoned()
		props.closePrompt()
		pcall(function()
			local CoreGui = game:GetService("CoreGui")
			local robloxGui = CoreGui:FindFirstChild("RobloxGui")
			local modules = robloxGui and robloxGui:FindFirstChild("Modules") or nil
			local settings = modules and modules:FindFirstChild("Settings") or nil
			local settingsHub = settings and settings:FindFirstChild("SettingsHub") or nil

			if not settingsHub then
				return
			end

			local module = require(settingsHub)
			module:SetVisibility(true, false, module.Instance.ReportAbusePage)
		end)
	end

	local v15

	if FFlagPlayerSupportPromptEventIngest then
		v15 = { category, v7, description, props.closePrompt, props.onFormAbandoned }
	else
		v15 = { props.closePrompt, props.onFormAbandoned }
	end

	local onActivated2 = useCallback2(fn3, v15)
	local v16

	if FFlagEnablePlayerSupportCaptureAttachments then
		v16 = React.useCallback(function()
			if state3 then
				setState3(nil)
			elseif state then
				setState(false)
			else
				v14()
			end
		end, { state3, state, v14 })
	else
		v16 = v14
	end

	useEscapeDismiss("PlayerSupportPromptCancel", v16)

	local createElement = React.createElement
	local root = Dialog.Root

	local createElement2 = React.createElement
	local title = Dialog.Title
	local text

	if FFlagEnablePlayerSupportCaptureAttachments and state and state3 ~= nil then
		if state3.CaptureTime == nil then
			text = v4.CapturesAdd
		else
			text = v10.dateTime
		end
	elseif FFlagEnablePlayerSupportCaptureAttachments and state then
		text = v4.CapturesAdd
	else
		text = v4.Title
	end

	local v17 = {
		Title = createElement2(title, { text = text }),
		Content = 0,
		Actions = 0
	}
	local content2

	if FFlagEnablePlayerSupportCaptureAttachments and state then
		local createElement3 = React.createElement
		local content = Dialog.Content
		local pickerBody

		if state3 == nil then
			pickerBody = React.createElement(CapturePickerGrid, {
				captures = v3.captures,
				isLoading = v3.isLoading,
				hasMore = v3.hasMore,
				selectedKeys = state2,
				maxSelections = 5,
				onToggle = onToggle,
				onPreview = function(p)
					setState3(p)
				end,
				onLoadMore = v3.loadMore
			})
		else
			pickerBody = React.createElement(CapturePickerPreview, { capture = state3 })
		end

		content2 = createElement3(content, { LayoutOrder = 1 }, { PickerBody = pickerBody })
	else
		local createElement3 = React.createElement
		local content = Dialog.Content

		local createElement4 = React.createElement
		local v18 = {
			tag = "col gap-medium size-full-0 auto-y",
			padding = {
				top = UDim.new(0, -(v.Gap.XLarge - v.Gap.Large))
			}
		}
		local children = {
			ReportAbuseRow = React.createElement(View, {
				tag = "row gap-small auto-y",
				LayoutOrder = 0
			}, {
				Lead = React.createElement(Text, {
					Text = v4.ReportAbuseLead,
					tag = "auto-xy",
					LayoutOrder = 1
				}),
				Link = React.createElement(Text, {
					Text = v4.ReportAbuseLink,
					RichText = true,
					onActivated = onActivated2,
					selection = { Selectable = true },
					tag = "auto-xy",
					LayoutOrder = 2
				})
			}),
			CategorySection = 0,
			Description = 0,
			CapturesSection = 0,
			ShareCheckboxRow = 0
		}

		local createElement5 = React.createElement

		local v19 = {
			Label = React.createElement(Text, {
				Text = v4.CategoryLabel,
				tag = "size-0 auto-xy text-title-medium text-wrap text-align-x-left text-align-y-top",
				textStyle = v.Color.Content.Emphasis,
				LayoutOrder = 1
			}),
			DropdownBorder = 0
		}

		local createElement6 = React.createElement
		local v20 = {
			Size = UDim2.new(1, -v.Stroke.Standard * 2, 0, 0),
			Position = UDim2.new(0, v.Stroke.Standard, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			tag = "radius-medium",
			stroke = {
				Color = v.Color.Stroke.Default.Color3,
				Thickness = v.Stroke.Standard,
				Transparency = v.Color.Stroke.Default.Transparency
			},
			cornerRadius = UDim.new(0, v.Radius.Medium),
			LayoutOrder = 2
		}

		local createElement7 = React.createElement
		local root2 = Dropdown.Root
		local v21

		if category ~= "" then
			v21 = category
		end

		v19.DropdownBorder = createElement6(View, v20, {
			Dropdown = createElement7(root2, {
				label = "",
				value = v21,
				placeholder = v4.CategoryPlaceholder,
				items = items,
				size = InputSize.Medium,
				variant = InputVariant.Utility,
				width = UDim.new(1, 0),
				onItemChanged = function(p)
					setCategory((tostring(p)))
				end
			})
		})
		children.CategorySection = createElement5(
			View,
			{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
			v19
		)

		children.Description = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			GroupTransparency = category == "" and 0.75 or 0,
			LayoutOrder = 2
		}, {
			Label = React.createElement(Text, {
				Text = v4.DescriptionLabel,
				tag = "size-0 auto-xy text-title-medium text-wrap text-align-x-left text-align-y-top",
				textStyle = v.Color.Content.Emphasis,
				LayoutOrder = 1
			}),
			InputBorderSlot = React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				InputBorder = React.createElement(View, {
					Size = UDim2.new(1, -v.Stroke.Standard * 2, 0, 0),
					Position = UDim2.new(0, v.Stroke.Standard, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					tag = "radius-medium",
					stroke = {
						Color = v.Color.Stroke.Default.Color3,
						Thickness = v.Stroke.Standard,
						Transparency = v.Color.Stroke.Default.Transparency
					},
					cornerRadius = UDim.new(0, v.Radius.Medium)
				}, {
					Input = React.createElement(TextArea, {
						text = description,
						onChanged = setDescription,
						placeholder = v5[category] or "",
						label = "",
						hint = "",
						width = UDim.new(1, 0),
						variant = InputVariant.Utility,
						numLines = 4,
						size = InputSize.Medium,
						isDisabled = category == ""
					})
				})
			}),
			Hint = React.createElement(Text, {
				Text = v4.DescriptionHint,
				tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left text-align-y-top",
				textStyle = v.Color.Content.Emphasis,
				LayoutOrder = 3
			})
		})
		local capturesSection

		if FFlagEnablePlayerSupportCaptureAttachments then
			capturesSection = React.createElement(memo, {
				uploadStatuses = v2.uploadStatuses,
				category = category,
				maxSelections = 5,
				onCaptureRemoved = v2.onCaptureRemoved,
				onPickerOpen = onPickerOpen
			})
		end

		children.CapturesSection = capturesSection

		local createElement8 = React.createElement

		local createElement9 = React.createElement
		local label

		if v6 then
			label = v4.ShareUserIdLabelRequired
		else
			label = v4.ShareUserIdLabel
		end

		children.ShareCheckboxRow = createElement8(View, {
			tag = "col gap-xsmall size-full-0 auto-y",
			LayoutOrder = FFlagEnablePlayerSupportCaptureAttachments and 4 or 3
		}, {
			Checkbox = createElement9(Checkbox, {
				label = label,
				isChecked = v7,
				isDisabled = v6,
				onActivated = function(flag: boolean)
					setShareUserId(flag)
				end,
				size = InputSize.Medium,
				LayoutOrder = 1
			}),
			HintRow = React.createElement(View, {
				tag = "size-full-0 auto-y",
				padding = {
					left = UDim.new(0, v.Size.Size_600 + v.Gap.Medium)
				},
				LayoutOrder = 2
			}, {
				Hint = React.createElement(Text, {
					Text = v4.ShareUserIdHint,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
				})
			})
		})
		content2 = createElement3(content, { LayoutOrder = 1 }, {
			Body = createElement4(View, v18, children)
		})
	end

	v17.Content = content2
	local actions2

	if FFlagEnablePlayerSupportCaptureAttachments and state then
		local createElement3 = React.createElement
		local actions = Dialog.Actions
		local v18 = { LayoutOrder = 2, actions = 0 }
		local actions3

		if state3 == nil then
			actions3 = { nil, nil }
			local v19 = { text = v4.Add, variant = 0, isDisabled = 0, onActivated = 0 }
			local variant

			if v8 > 0 then
				variant = ButtonVariant.Emphasis
			else
				variant = ButtonVariant.Standard
			end

			v19.variant = variant

			v19.isDisabled = v8 == 0 and not next(v2.uploadStatuses)
			v19.onActivated = fn

			actions3[1], actions3[2] = v19, {
	text = v4.Cancel,
	variant = ButtonVariant.Standard,
	onActivated = function()
		setState(false)
	end
}
		else
			local v19 = state2[getCaptureKey(state3)] == true
			local v20 = v19 or not v9
			actions3 = { nil, nil }

			local text2 = if v19 then v4.Deselect else v4.Select
			local variant

			if v19 then
				variant = ButtonVariant.SoftEmphasis
			elseif v20 then
				variant = ButtonVariant.Emphasis
			else
				variant = ButtonVariant.Standard
			end

			actions3[1], actions3[2] = {
	text = text2,
	variant = variant,
	isDisabled = not (v20 or v19),
	onActivated = function()
		onToggle(state3)
		setState3(nil)
	end
}, {
	text = v4.Cancel,
	variant = ButtonVariant.Standard,
	onActivated = function()
		setState3(nil)
	end
}
		end

		v18.actions = actions3
		actions2 = createElement3(actions, v18)
	else
		local createElement3 = React.createElement
		local actions = Dialog.Actions

		local v18 = { text = v4.Send, variant = 0, onActivated = 0, isDisabled = 0 }
		local variant

		if v11 then
			variant = ButtonVariant.Emphasis
		else
			variant = ButtonVariant.Standard
		end

		v18.variant = variant
		v18.onActivated = onActivated
		v18.isDisabled = not v11
		actions2 = createElement3(actions, {
			LayoutOrder = 2,
			actions = { v18 }
		})
	end

	v17.Actions = actions2
	return createElement(root, { onClose = onClose, hasBackdrop = true }, v17)
end))
