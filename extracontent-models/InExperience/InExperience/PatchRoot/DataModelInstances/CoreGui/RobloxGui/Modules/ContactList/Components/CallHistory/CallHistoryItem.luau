local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local ContactList = RobloxGui.Modules.ContactList
local dependencies = require(ContactList.dependencies)
local useDispatch = dependencies.Hooks.useDispatch
local UIBlox = dependencies.UIBlox
local getStandardSizeAvatarHeadShotRbxthumb = dependencies.getStandardSizeAvatarHeadShotRbxthumb
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local useStyle = UIBlox.Core.Style.useStyle
local CallState = require(ContactList.Enums.CallState)
local random = Random.new()
local OpenOrUpdateCFM = require(ContactList.Actions.OpenOrUpdateCFM)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local Pages = require(ContactList.Enums.Pages)
local useStartCallCallback = require(ContactList.Hooks.useStartCallCallback)
local vector2 = Vector2.new(24, 12)

local function getIsMissedCall(p1, p2) -- line: 67
	-- upvalues: CallState (copy)
	return p2 ~= p1.callerId and p1.status ~= CallState.Finished
end
local function getCallStatusText(p3, p4) -- line: 71
	-- upvalues: CallState (copy)
	if p4 ~= p3.callerId and p3.status ~= CallState.Finished then
		return "Feature.Call.Label.Missed"
	end

	if p4 == p3.callerId then
		return "Feature.Call.Label.Outgoing"
	end

	return "Feature.Call.Label.Incoming"
end
local function getCallContextImage(p5, p6) -- line: 81
	-- upvalues: CallState (copy)
	if p6 ~= p5.callerId and p5.status ~= CallState.Finished then
		return "rbxassetid://15239344406"
	end

	if p6 == p5.callerId then
		return "rbxassetid://15239341275"
	end

	return "rbxassetid://15239341959"
end
local function getAbsoluteDiffDays(p7, p8, p9) -- line: 92
	local num = tonumber(p7:FormatLocalTime("YYYY", p9))
	local num2 = tonumber(p8:FormatLocalTime("YYYY", p9))
	local num3 = tonumber(p7:FormatLocalTime("DDD", p9))
	local num4 = tonumber(p8:FormatLocalTime("DDD", p9))
	local n1 = 0

	for i = num2, num - 1 do
		local n2 = 365

		if i % 4 == 0 and (i % 100 ~= 0 or i % 400 == 0) then
			n2 = 366
		end

		n1 += n2
	end

	return n1 + num3 - num4
end
local function getTimestampText(p10, p11) -- line: 113
	-- upvalues: LocalizationService (copy), getAbsoluteDiffDays (copy)
	local dateTime = DateTime.now()
	local dateTime2 = DateTime.fromUnixTimestampMillis(p10)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v56 = getAbsoluteDiffDays(dateTime, dateTime2, RobloxLocaleId)

	if v56 == 0 then
		return dateTime2:FormatLocalTime("LT", RobloxLocaleId)
	end

	if v56 == 1 then
		return p11
	end

	if v56 < 7 then
		return dateTime2:FormatLocalTime("dddd", RobloxLocaleId)
	end

	return dateTime2:FormatLocalTime("L", RobloxLocaleId)
end
local function CallHistoryItem(t1: {[any]: any}) -- line: 131
	-- upvalues: UserProfiles (copy), useLocalization (copy), CallState (copy), useAnalytics (copy), useStyle (copy), useDispatch (copy), React (copy), ControlState (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy), useSelector (copy), useStartCallCallback (copy), EventNamesEnum (copy), Pages (copy), OpenOrUpdateCFM (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), Interactable (copy), vector2 (copy), ImageSetLabel (copy), getTimestampText (copy)
	local callRecord = t1.callRecord
	local localUserId = t1.localUserId

	assert(#callRecord.participants == 2, "Expect a local user and single other participant in call.")

	local userId = callRecord.participants[1].userId

	if localUserId == userId then
		userId = callRecord.participants[2].userId
	end

	local s1 = ""
	local s2 = ""
	local t2 = nil
	local v64 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(userId)) },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	if v64.data then
		s1 = UserProfiles.Selectors.getCombinedNameFromId(v64.data, userId)

		local v65 = UserProfiles.Selectors.getUsernameFromId(v64.data, userId)

		t2 = {
			userId = userId,
			userName = v65,
			combinedName = s1
		}
		s2 = UserProfiles.Formatters.formatUsername(v65)
	end

	local v66 = useLocalization({
		yesterdayLabel = "Feature.Call.Label.Yesterday",
		callStatusLabel = if not (localUserId ~= callRecord.callerId and callRecord.status ~= CallState.Finished) then localUserId ~= callRecord.callerId and "Feature.Call.Label.Incoming" or "Feature.Call.Label.Outgoing" else "Feature.Call.Label.Missed"
	})
	local callStatusLabel = v66.callStatusLabel
	local yesterdayLabel = v66.yesterdayLabel
	local v69 = useAnalytics()
	local v70 = useStyle()
	local Theme = v70.Theme
	local Font = v70.Font
	local v73 = useDispatch()
	local v74, v75 = React.useState("BackgroundDefault")
	local v76 = React.useCallback(function(_, p13) -- line: 178
		-- upvalues: ControlState (copy), v75 (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy)
		if p13 == ControlState.Pressed then
			v75("BackgroundOnPress")

			return
		end

		if p13 == ControlState.Hover then
			v75("BackgroundOnHover")
			SoundManager:PlaySound(Sounds.Hover.Name, {
				Volume = 0.5 + random:NextNumber(-0.25, 0.25),
				PlaybackSpeed = 1 + random:NextNumber(-0.5, 0.5)
			}, SoundGroups.Iris)

			return
		end

		v75("BackgroundDefault")
	end, {})
	local v77 = React.useCallback(function(p14) -- line: 192
		return p14.Navigation.currentTag
	end, {})
	local v78 = useSelector(v77)
	local v79 = React.useCallback(function(p15) -- line: 197
		return p15.Navigation.currentPage
	end, {})
	local v80 = useSelector(v79)
	local t3 = {
		searchQueryString = "",
		isSuggestedUser = false,
		itemListIndex = t1.layoutOrder,
		page = v80
	}
	local v82 = useStartCallCallback(v78, userId, s1, t1.dismissCallback, t3)
	local v83 = React.useCallback(function() -- line: 210
		-- upvalues: v69 (copy), EventNamesEnum (copy), userId (ref), t1 (copy), Pages (copy), v73 (copy), OpenOrUpdateCFM (copy), t2 (ref)
		v69.fireEvent(EventNamesEnum.PhoneBookPlayerMenuOpened, {
			searchQueryString = nil,
			isSuggestedUser = false,
			eventTimestampMs = os.time() * 1000,
			friendUserId = userId,
			itemListIndex = t1.layoutOrder,
			page = Pages.CallHistory
		})
		v73(OpenOrUpdateCFM(t2))
	end, {
		userId,
		t1.layoutOrder
	})
	local v84 = getStandardSizeAvatarHeadShotRbxthumb((tostring(userId)))
	local v85 = localUserId ~= callRecord.callerId and callRecord.status ~= CallState.Finished

	return React.createElement(Interactable, {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 68 + vector2.Y * 2),
		BackgroundColor3 = Theme[v74].Color,
		BackgroundTransparency = Theme[v74].Transparency,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		onStateChanged = v76,
		AutoButtonColor = false,
		[React.Event.Activated] = v82
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, vector2.X),
			PaddingTop = UDim.new(0, vector2.Y)
		}),
		ProfileImage = React.createElement("ImageButton", {
			Size = UDim2.fromOffset(68, 68),
			Image = v84,
			[React.Event.MouseButton2Up] = v83,
			[React.Event.TouchTap] = v83,
			AutoButtonColor = false
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -(104 + vector2.X), 1, -vector2.Y)
		}, {
			NameContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				DisplayName = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 20),
					Font = Font.Header2.Font,
					Text = s1,
					TextColor3 = if not v85 then Theme.TextEmphasis.Color else Theme.Alert.Color,
					TextSize = Font.BaseSize * Font.Header2.RelativeSize,
					TextTransparency = if not v85 then Theme.TextEmphasis.Transparency else Theme.Alert.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Username = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 14),
					Font = Font.CaptionBody.Font,
					Text = s2,
					TextColor3 = Theme.TextDefault.Color,
					TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
					TextTransparency = Theme.TextDefault.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			Details = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Position = UDim2.new(0, 0, 1, -16),
				Size = UDim2.new(1, 0, 0, 16)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 4)
				}),
				CallContextImage = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(16, 16),
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency,
					Image = if not (localUserId ~= callRecord.callerId and callRecord.status ~= CallState.Finished) then localUserId ~= callRecord.callerId and "rbxassetid://15239341959" or "rbxassetid://15239341275" else "rbxassetid://15239344406"
				}),
				DetailsText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(0, 14),
					AutomaticSize = Enum.AutomaticSize.X,
					Font = Font.CaptionBody.Font,
					Text = callStatusLabel .. " • " .. getTimestampText(callRecord.endUtc, yesterdayLabel),
					TextColor3 = Theme.TextDefault.Color,
					TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
					TextTransparency = Theme.TextDefault.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			})
		}),
		CallIcon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = "rbxassetid://15239343417",
			Position = UDim2.new(1, -vector2.X - 4, 0.5, -vector2.Y / 2),
			Size = UDim2.fromOffset(24, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			ImageColor3 = Theme.ContextualPrimaryDefault.Color,
			ImageTransparency = Theme.ContextualPrimaryDefault.Transparency
		}),
		Divider = t1.showDivider and React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency
		}) or nil
	})
end

return CallHistoryItem
