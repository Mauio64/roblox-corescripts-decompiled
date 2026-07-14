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
local CurrentCamera = workspace.CurrentCamera
local v32 = 12 + Constants.ApplyDisplayScale(Constants.TopBarHeight)

local function ContactListContainer() -- line: 62
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useIsSpatial (copy), React (copy), CurrentCamera (copy), v32 (copy), Signal (copy), useSelector (copy), SocialService (copy), LocalPlayer (copy), SetCurrentTag (copy), EventNamesEnum (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), PeekViewState (copy), CallHistoryContainer (copy), FriendListContainer (copy), ContactListHeader (copy), ContactListSearchBar (copy), PeekView (copy)
	local v34 = useAnalytics()
	local Theme = useStyle().Theme
	local v36 = useDispatch()
	local v37 = useIsSpatial()
	local v38 = React.useRef(nil)
	local v39, v40 = React.useState(0)
	local v41, v42 = React.useState(CurrentCamera.ViewportSize.X < 640)
	local v43, v44 = React.useState("")
	local v45, v46 = React.useState(CurrentCamera.ViewportSize.Y - v32)
	local v47, v48 = React.useState(nil)
	local v49 = React.useRef(Signal.new())
	local v50 = React.useCallback(function(p1) -- line: 85
		return p1.Navigation.currentPage
	end, {})
	local v51 = useSelector(v50)

	React.useEffect(function() -- line: 90
		-- upvalues: SocialService (copy), LocalPlayer (copy), v37 (copy), v36 (copy), SetCurrentTag (copy), v34 (copy), EventNamesEnum (copy), v51 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), v40 (copy), v39 (copy)
		local connection = SocialService.PromptIrisInviteRequested:Connect(function(p2, s1: string) -- line: 92
			-- upvalues: LocalPlayer (copy), v37 (copy), v36 (copy), SetCurrentTag (copy), v34 (copy), EventNamesEnum (copy), v51 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), SocialService (copy)
			if LocalPlayer and LocalPlayer.UserId == p2.UserId then
				if not v37 then
					v36(SetCurrentTag(s1))
					v34.fireEvent(EventNamesEnum.PhoneBookNavigate, {
						eventTimestampMs = os.time() * 1000,
						startingPage = v51,
						destinationPage = Pages.CallHistory
					})
					v36(SetCurrentPage(Pages.CallHistory))
					SoundManager:PlaySound(Sounds.Swipe.Name, {
						Volume = 0.5
					}, SoundGroups.Iris)

					return
				end

				v36(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Label.OhNo"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.DeviceNotSupported"), function() -- line: 109
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end))
			end
		end)
		local connection2 = SocialService.PhoneBookPromptClosed:Connect(function(p3) -- line: 121
			-- upvalues: LocalPlayer (copy), v34 (copy), EventNamesEnum (copy), v51 (copy), v36 (copy), SetCurrentPage (copy), v40 (copy), v39 (copy)
			if LocalPlayer and LocalPlayer.UserId == p3.UserId then
				v34.fireEvent(EventNamesEnum.PhoneBookNavigate, {
					destinationPage = nil,
					eventTimestampMs = os.time() * 1000,
					startingPage = tostring(v51)
				})
				v36(SetCurrentPage(nil))
				v40(v39 + 1)
			end
		end)

		return function() -- line: 134
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		v39,
		v51
	})

	local v52 = React.useCallback(function() -- line: 140
		-- upvalues: v41 (copy), v38 (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), SocialService (copy), LocalPlayer (copy), v49 (copy)
		if not v41 and v38.current then
			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			pcall(function() -- line: 143
				-- upvalues: v38 (copy), v32 (copy), SocialService (copy), LocalPlayer (copy)
				v38.current:TweenPositionInternal(UDim2.new(0, -376, 0, v32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true, function() -- line: 150
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end)
			end)

			return
		end

		if v49 and v49.current then
			v49.current:fire()
		end
	end, { v41 })
	local v53 = React.useCallback(function(p4) -- line: 162
		-- upvalues: v44 (copy)
		v44(p4)
	end, {})

	React.useEffect(function() -- line: 167
		-- upvalues: CurrentCamera (copy), v42 (copy), v46 (copy), v32 (copy)
		local connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 168
			-- upvalues: CurrentCamera (copy), v42 (copy), v46 (copy), v32 (copy)
			if CurrentCamera.ViewportSize.X < 640 then
				v42(true)
			else
				v42(false)
			end

			v46(CurrentCamera.ViewportSize.Y - v32)
		end)

		return function() -- line: 178
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 183
		-- upvalues: v51 (copy), v41 (copy), v38 (copy), v32 (copy), v44 (copy)
		if v51 and (not v41 and v38.current) then
			pcall(function() -- line: 185
				-- upvalues: v38 (copy), v32 (copy)
				v38.current:TweenPositionInternal(UDim2.new(0, 12, 0, v32), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
			end)
		end

		v44("")
	end, {
		v41,
		v51
	})

	local v54 = React.useCallback(function(p5, _) -- line: 200
		-- upvalues: PeekViewState (copy), LocalPlayer (copy), SocialService (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v48 (copy)
		if p5 == PeekViewState.Closed then
			if LocalPlayer then
				SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
			end

			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
		end

		v48(p5)
	end, {})
	local v55 = React.useCallback(function() -- line: 212
		-- upvalues: v34 (copy), EventNamesEnum (copy), v51 (copy), Pages (copy), v36 (copy), SetCurrentPage (copy), v48 (copy), PeekViewState (copy)
		v34.fireEvent(EventNamesEnum.PhoneBookSearchClicked, {
			eventTimestampMs = os.time() * 1000
		})

		if v51 ~= Pages.FriendList then
			v34.fireEvent(EventNamesEnum.PhoneBookNavigate, {
				eventTimestampMs = os.time() * 1000,
				startingPage = v51,
				destinationPage = Pages.FriendList
			})
		end

		v36(SetCurrentPage(Pages.FriendList))
		v48(PeekViewState.Full)
	end, { v51 })
	local v56 = React.useMemo(function() -- line: 226
		-- upvalues: v51 (copy), Pages (copy), React (copy), CallHistoryContainer (copy), v52 (copy), v41 (copy), v47 (copy), PeekViewState (copy), v43 (copy), FriendListContainer (copy), v45 (copy), v32 (copy), Theme (copy), v38 (copy), ContactListHeader (copy), ContactListSearchBar (copy), v53 (copy), v55 (copy)
		local v65 = nil

		if v51 == Pages.CallHistory then
			v65 = React.createElement(CallHistoryContainer, {
				dismissCallback = v52,
				isSmallScreen = v41,
				scrollingEnabled = not v41 or v47 == PeekViewState.Full,
				searchText = v43
			})
		elseif v51 == Pages.FriendList then
			v65 = React.createElement(FriendListContainer, {
				dismissCallback = v52,
				isSmallScreen = v41,
				scrollingEnabled = not v41 or v47 == PeekViewState.Full,
				searchText = v43
			})
		end

		return React.createElement("ImageButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = if not v41 then UDim2.new(0, 376, 1, -v32) else UDim2.new(1, 0, 0, v45 - 25),
			Position = if not v41 then UDim2.new(0, -376, 0, v32) else UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ref = v38
		}, {
			UICorner = if not v41 then React.createElement("UICorner", {
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
				currentPage = v51,
				dismissCallback = v52
			}),
			SearchBar = React.createElement(ContactListSearchBar, {
				layoutOrder = 2,
				searchBarHeight = 36,
				onSearchChanged = v53,
				searchText = v43,
				onFocused = v55
			}),
			ContentContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -88)
			}, v65)
		})
	end, {
		v45,
		v51,
		v52,
		v47,
		v41,
		v43
	})
	local t1 = {}

	if v41 then
		t1["ContactListContent" .. tostring(v39)] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v32),
			Position = UDim2.fromOffset(0, v32)
		}, { React.createElement(PeekView, {
			canDragFullViewToBrief = true,
			briefViewContentHeight = UDim.new(0.6, 0),
			closeSignal = v49.current,
			elasticBehavior = Enum.ElasticBehavior.Never,
			peekViewState = v47,
			viewStateChanged = v54
		}, {
			Content = v56
		}) })
	else
		t1.ContactListContent = v56
	end

	if v51 then
		return (React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = function() -- line: 328
				-- upvalues: v52 (copy)
				v52()
			end
		}, t1))
	end

	return nil
end

return ContactListContainer
