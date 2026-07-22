local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local SocialService = game:GetService("SocialService")
local React = require(CorePackages.Packages.React)
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ContactList = RobloxGui.Modules.ContactList
local dependencies = require(ContactList.dependencies)
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useStyle = dependencies.UIBlox.Core.Style.useStyle
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local ContactListHeader = require(ContactList.Components.ContactListHeader)
local CallHistoryContainer = require(ContactList.Components.CallHistory.CallHistoryContainer)
local FriendListContainer = require(ContactList.Components.FriendList.FriendListContainer)
local ContactListSearchBar = require(ContactList.Components.ContactListSearchBar)
local SetCurrentPage = require(ContactList.Actions.SetCurrentPage)
local SetCurrentTag = require(ContactList.Actions.SetCurrentTag)
local OpenOrUpdateDialog = require(ContactList.Actions.OpenOrUpdateDialog)
local Pages = require(ContactList.Enums.Pages)
local Constants = require(ContactList.Parent.TopBar.Constants)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v31 = game:DefineFastFlag("FixContactListNilCamera2", false)
local v32 = if not v31 then workspace.CurrentCamera else workspace.CurrentCamera

local function getCameraViewportSize() -- line: 51
	-- upvalues: v31 (copy), v32 (copy)
	if v31 then
		if v32 then
			return v32.ViewportSize
		end

		return Vector2.new(0, 0)
	end

	return v32.ViewportSize
end

local v34 = 12 + Constants.ApplyDisplayScale(Constants.TopBarHeight)

local function ContactListContainer() -- line: 75
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useIsSpatial (copy), React (copy), v31 (copy), v32 (copy), v34 (copy), Signal (copy), useSelector (copy), SocialService (copy), LocalPlayer (copy), SetCurrentTag (copy), EventNamesEnum (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), PeekViewState (copy), CallHistoryContainer (copy), FriendListContainer (copy), ContactListHeader (copy), ContactListSearchBar (copy), PeekView (copy)
	local v36 = useAnalytics()
	local Theme = useStyle().Theme
	local v38 = useDispatch()
	local v39 = useIsSpatial()
	local v40 = React.useRef(nil)
	local v41, v42 = React.useState(0)
	local v43, v44 = React.useState(((if not v31 then v32.ViewportSize else (if not v32 then Vector2.new(0, 0) else v32.ViewportSize))).X < 640)
	local v45, v46 = React.useState("")
	local v47, v48 = React.useState(((if not v31 then v32.ViewportSize else (if not v32 then Vector2.new(0, 0) else v32.ViewportSize))).Y - v34)
	local v49, v50 = React.useState(nil)
	local v51 = React.useRef(Signal.new())
	local v52 = React.useCallback(function(p1) -- line: 98
		return p1.Navigation.currentPage
	end, {})
	local v53 = useSelector(v52)

	React.useEffect(function() -- line: 103
		-- upvalues: SocialService (copy), LocalPlayer (copy), v39 (copy), v38 (copy), SetCurrentTag (copy), v36 (copy), EventNamesEnum (copy), v53 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), v42 (copy), v41 (copy)
		local connection = SocialService.PromptIrisInviteRequested:Connect(function(p2, s1: string) -- line: 105
			-- upvalues: LocalPlayer (copy), v39 (copy), v38 (copy), SetCurrentTag (copy), v36 (copy), EventNamesEnum (copy), v53 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), SocialService (copy)
			if LocalPlayer and LocalPlayer.UserId == p2.UserId then
				if not v39 then
					v38(SetCurrentTag(s1))
					v36.fireEvent(EventNamesEnum.PhoneBookNavigate, {
						eventTimestampMs = os.time() * 1000,
						startingPage = v53,
						destinationPage = Pages.CallHistory
					})
					v38(SetCurrentPage(Pages.CallHistory))
					SoundManager:PlaySound(Sounds.Swipe.Name, {
						Volume = 0.5
					}, SoundGroups.Iris)

					return
				end

				v38(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Label.OhNo"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.DeviceNotSupported"), function() -- line: 122
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end))
			end
		end)
		local connection2 = SocialService.PhoneBookPromptClosed:Connect(function(p3) -- line: 134
			-- upvalues: LocalPlayer (copy), v36 (copy), EventNamesEnum (copy), v53 (copy), v38 (copy), SetCurrentPage (copy), v42 (copy), v41 (copy)
			if LocalPlayer and LocalPlayer.UserId == p3.UserId then
				v36.fireEvent(EventNamesEnum.PhoneBookNavigate, {
					destinationPage = nil,
					eventTimestampMs = os.time() * 1000,
					startingPage = tostring(v53)
				})
				v38(SetCurrentPage(nil))
				v42(v41 + 1)
			end
		end)

		return function() -- line: 147
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		v41,
		v53
	})

	local v54 = React.useCallback(function() -- line: 153
		-- upvalues: v43 (copy), v40 (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v34 (copy), SocialService (copy), LocalPlayer (copy), v51 (copy)
		if not v43 and v40.current then
			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			pcall(function() -- line: 156
				-- upvalues: v40 (copy), v34 (copy), SocialService (copy), LocalPlayer (copy)
				v40.current:TweenPositionInternal(UDim2.new(0, -376, 0, v34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true, function() -- line: 163
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end)
			end)

			return
		end

		if v51 and v51.current then
			v51.current:fire()
		end
	end, { v43 })
	local v55 = React.useCallback(function(p4) -- line: 175
		-- upvalues: v46 (copy)
		v46(p4)
	end, {})

	React.useEffect(function() -- line: 180
		-- upvalues: v31 (copy), v32 (copy), v44 (copy), v48 (copy), v34 (copy)
		if v31 and not v32 then
			return function() -- line: 182
			end
		end

		local connection = v32:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 184
			-- upvalues: v31 (copy), v32 (copy), v44 (copy), v48 (copy), v34 (copy)
			if ((if not v31 then v32.ViewportSize else (if not v32 then Vector2.new(0, 0) else v32.ViewportSize))).X < 640 then
				v44(true)
			else
				v44(false)
			end

			v48(((if not v31 then v32.ViewportSize else (if not v32 then Vector2.new(0, 0) else v32.ViewportSize))).Y - v34)
		end)

		return function() -- line: 194
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 199
		-- upvalues: v53 (copy), v43 (copy), v40 (copy), v34 (copy), v46 (copy)
		if v53 and (not v43 and v40.current) then
			pcall(function() -- line: 201
				-- upvalues: v40 (copy), v34 (copy)
				v40.current:TweenPositionInternal(UDim2.new(0, 12, 0, v34), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
			end)
		end

		v46("")
	end, {
		v43,
		v53
	})

	local v56 = React.useCallback(function(p5, _) -- line: 216
		-- upvalues: PeekViewState (copy), LocalPlayer (copy), SocialService (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v50 (copy)
		if p5 == PeekViewState.Closed then
			if LocalPlayer then
				SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
			end

			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
		end

		v50(p5)
	end, {})
	local v57 = React.useCallback(function() -- line: 228
		-- upvalues: v36 (copy), EventNamesEnum (copy), v53 (copy), Pages (copy), v38 (copy), SetCurrentPage (copy), v50 (copy), PeekViewState (copy)
		v36.fireEvent(EventNamesEnum.PhoneBookSearchClicked, {
			eventTimestampMs = os.time() * 1000
		})

		if v53 ~= Pages.FriendList then
			v36.fireEvent(EventNamesEnum.PhoneBookNavigate, {
				eventTimestampMs = os.time() * 1000,
				startingPage = v53,
				destinationPage = Pages.FriendList
			})
		end

		v38(SetCurrentPage(Pages.FriendList))
		v50(PeekViewState.Full)
	end, { v53 })
	local v58 = React.useMemo(function() -- line: 242
		-- upvalues: v53 (copy), Pages (copy), React (copy), CallHistoryContainer (copy), v54 (copy), v43 (copy), v49 (copy), PeekViewState (copy), v45 (copy), FriendListContainer (copy), v47 (copy), v34 (copy), Theme (copy), v40 (copy), ContactListHeader (copy), ContactListSearchBar (copy), v55 (copy), v57 (copy)
		local v67 = nil

		if v53 == Pages.CallHistory then
			v67 = React.createElement(CallHistoryContainer, {
				dismissCallback = v54,
				isSmallScreen = v43,
				scrollingEnabled = not v43 or v49 == PeekViewState.Full,
				searchText = v45
			})
		elseif v53 == Pages.FriendList then
			v67 = React.createElement(FriendListContainer, {
				dismissCallback = v54,
				isSmallScreen = v43,
				scrollingEnabled = not v43 or v49 == PeekViewState.Full,
				searchText = v45
			})
		end

		return React.createElement("ImageButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = if not v43 then UDim2.new(0, 376, 1, -v34) else UDim2.new(1, 0, 0, v47 - 25),
			Position = if not v43 then UDim2.new(0, -376, 0, v34) else UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ref = v40
		}, {
			UICorner = if not v43 then React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			}) else nil,
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			Header = React.createElement(ContactListHeader, {
				headerHeight = 36,
				layoutOrder = 1,
				currentPage = v53,
				dismissCallback = v54
			}),
			SearchBar = React.createElement(ContactListSearchBar, {
				layoutOrder = 2,
				searchBarHeight = 36,
				onSearchChanged = v55,
				searchText = v45,
				onFocused = v57
			}),
			ContentContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -88)
			}, v67)
		})
	end, {
		v47,
		v53,
		v54,
		v49,
		v43,
		v45
	})
	local t1 = {}

	if v43 then
		t1["ContactListContent" .. tostring(v41)] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v34),
			Position = UDim2.fromOffset(0, v34)
		}, { React.createElement(PeekView, {
			canDragFullViewToBrief = true,
			briefViewContentHeight = UDim.new(0.6, 0),
			closeSignal = v51.current,
			elasticBehavior = Enum.ElasticBehavior.Never,
			peekViewState = v49,
			viewStateChanged = v56
		}, {
			Content = v58
		}) })
	else
		t1.ContactListContent = v58
	end

	if v53 then
		return (React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = function() -- line: 344
				-- upvalues: v54 (copy)
				v54()
			end
		}, t1))
	end

	return nil
end

return ContactListContainer
