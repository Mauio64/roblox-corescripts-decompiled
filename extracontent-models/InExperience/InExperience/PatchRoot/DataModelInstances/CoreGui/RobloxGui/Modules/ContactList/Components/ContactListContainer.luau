local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local SocialService = game:GetService("SocialService")
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
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
local v33 = 12 + Constants.ApplyDisplayScale(Constants.TopBarHeight)

local function ContactListContainer() -- line: 64
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useIsSpatial (copy), React (copy), CurrentCamera (copy), v33 (copy), Signal (copy), useSelector (copy), SocialService (copy), LocalPlayer (copy), SetCurrentTag (copy), EventNamesEnum (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), EngineFeature (copy), PeekViewState (copy), CallHistoryContainer (copy), FriendListContainer (copy), ContactListHeader (copy), ContactListSearchBar (copy), PeekView (copy)
	local v35 = useAnalytics()
	local Theme = useStyle().Theme
	local v37 = useDispatch()
	local v38 = useIsSpatial()
	local v39 = React.useRef(nil)
	local v40, v41 = React.useState(0)
	local v42, v43 = React.useState(CurrentCamera.ViewportSize.X < 640)
	local v44, v45 = React.useState("")
	local v46, v47 = React.useState(CurrentCamera.ViewportSize.Y - v33)
	local v48, v49 = React.useState(nil)
	local v50 = React.useRef(Signal.new())
	local v51 = React.useCallback(function(p1) -- line: 87
		return p1.Navigation.currentPage
	end, {})
	local v52 = useSelector(v51)

	React.useEffect(function() -- line: 92
		-- upvalues: SocialService (copy), LocalPlayer (copy), v38 (copy), v37 (copy), SetCurrentTag (copy), v35 (copy), EventNamesEnum (copy), v52 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), v41 (copy), v40 (copy)
		local connection = SocialService.PromptIrisInviteRequested:Connect(function(p2, s1: string) -- line: 94
			-- upvalues: LocalPlayer (copy), v38 (copy), v37 (copy), SetCurrentTag (copy), v35 (copy), EventNamesEnum (copy), v52 (copy), Pages (copy), SetCurrentPage (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), SocialService (copy)
			if LocalPlayer and LocalPlayer.UserId == p2.UserId then
				if not v38 then
					v37(SetCurrentTag(s1))
					v35.fireEvent(EventNamesEnum.PhoneBookNavigate, {
						eventTimestampMs = os.time() * 1000,
						startingPage = v52,
						destinationPage = Pages.CallHistory
					})
					v37(SetCurrentPage(Pages.CallHistory))
					SoundManager:PlaySound(Sounds.Swipe.Name, {
						Volume = 0.5
					}, SoundGroups.Iris)

					return
				end

				v37(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Label.OhNo"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.DeviceNotSupported"), function() -- line: 111
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end))
			end
		end)
		local connection2 = SocialService.PhoneBookPromptClosed:Connect(function(p3) -- line: 123
			-- upvalues: LocalPlayer (copy), v35 (copy), EventNamesEnum (copy), v52 (copy), v37 (copy), SetCurrentPage (copy), v41 (copy), v40 (copy)
			if LocalPlayer and LocalPlayer.UserId == p3.UserId then
				v35.fireEvent(EventNamesEnum.PhoneBookNavigate, {
					destinationPage = nil,
					eventTimestampMs = os.time() * 1000,
					startingPage = tostring(v52)
				})
				v37(SetCurrentPage(nil))
				v41(v40 + 1)
			end
		end)

		return function() -- line: 136
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		v40,
		v52
	})

	local v53 = React.useCallback(function() -- line: 142
		-- upvalues: v42 (copy), v39 (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), EngineFeature (copy), v33 (copy), SocialService (copy), LocalPlayer (copy), v50 (copy)
		if not v42 and v39.current then
			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			pcall(function() -- line: 145
				-- upvalues: EngineFeature (copy), v39 (copy), v33 (copy), SocialService (copy), LocalPlayer (copy)
				if EngineFeature then
					v39.current:TweenPositionInternal(UDim2.new(0, -376, 0, v33), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true, function() -- line: 153
						-- upvalues: SocialService (copy), LocalPlayer (copy)
						SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
					end)

					return
				end

				v39.current:TweenPosition(UDim2.new(0, -376, 0, v33), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true, function() -- line: 164
					-- upvalues: SocialService (copy), LocalPlayer (copy)
					SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
				end)
			end)

			return
		end

		if v50 and v50.current then
			v50.current:fire()
		end
	end, { v42 })
	local v54 = React.useCallback(function(p4) -- line: 177
		-- upvalues: v45 (copy)
		v45(p4)
	end, {})

	React.useEffect(function() -- line: 182
		-- upvalues: CurrentCamera (copy), v43 (copy), v47 (copy), v33 (copy)
		local connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 183
			-- upvalues: CurrentCamera (copy), v43 (copy), v47 (copy), v33 (copy)
			if CurrentCamera.ViewportSize.X < 640 then
				v43(true)
			else
				v43(false)
			end

			v47(CurrentCamera.ViewportSize.Y - v33)
		end)

		return function() -- line: 193
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 198
		-- upvalues: v52 (copy), v42 (copy), v39 (copy), EngineFeature (copy), v33 (copy), v45 (copy)
		if v52 and (not v42 and v39.current) then
			pcall(function() -- line: 200
				-- upvalues: EngineFeature (copy), v39 (copy), v33 (copy)
				if EngineFeature then
					v39.current:TweenPositionInternal(UDim2.new(0, 12, 0, v33), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)

					return
				end

				v39.current:TweenPosition(UDim2.new(0, 12, 0, v33), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
			end)
		end

		v45("")
	end, {
		v42,
		v52
	})

	local v55 = React.useCallback(function(p5, _) -- line: 225
		-- upvalues: PeekViewState (copy), LocalPlayer (copy), SocialService (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v49 (copy)
		if p5 == PeekViewState.Closed then
			if LocalPlayer then
				SocialService:InvokeIrisInvitePromptClosed(LocalPlayer)
			end

			SoundManager:PlaySound(Sounds.Swipe.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
		end

		v49(p5)
	end, {})
	local v56 = React.useCallback(function() -- line: 237
		-- upvalues: v35 (copy), EventNamesEnum (copy), v52 (copy), Pages (copy), v37 (copy), SetCurrentPage (copy), v49 (copy), PeekViewState (copy)
		v35.fireEvent(EventNamesEnum.PhoneBookSearchClicked, {
			eventTimestampMs = os.time() * 1000
		})

		if v52 ~= Pages.FriendList then
			v35.fireEvent(EventNamesEnum.PhoneBookNavigate, {
				eventTimestampMs = os.time() * 1000,
				startingPage = v52,
				destinationPage = Pages.FriendList
			})
		end

		v37(SetCurrentPage(Pages.FriendList))
		v49(PeekViewState.Full)
	end, { v52 })
	local v57 = React.useMemo(function() -- line: 251
		-- upvalues: v52 (copy), Pages (copy), React (copy), CallHistoryContainer (copy), v53 (copy), v42 (copy), v48 (copy), PeekViewState (copy), v44 (copy), FriendListContainer (copy), v46 (copy), v33 (copy), Theme (copy), v39 (copy), ContactListHeader (copy), ContactListSearchBar (copy), v54 (copy), v56 (copy)
		local v66 = nil

		if v52 == Pages.CallHistory then
			v66 = React.createElement(CallHistoryContainer, {
				dismissCallback = v53,
				isSmallScreen = v42,
				scrollingEnabled = not v42 or v48 == PeekViewState.Full,
				searchText = v44
			})
		elseif v52 == Pages.FriendList then
			v66 = React.createElement(FriendListContainer, {
				dismissCallback = v53,
				isSmallScreen = v42,
				scrollingEnabled = not v42 or v48 == PeekViewState.Full,
				searchText = v44
			})
		end

		return React.createElement("ImageButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = if not v42 then UDim2.new(0, 376, 1, -v33) else UDim2.new(1, 0, 0, v46 - 25),
			Position = if not v42 then UDim2.new(0, -376, 0, v33) else UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			ref = v39
		}, {
			UICorner = if not v42 then React.createElement("UICorner", {
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
				currentPage = v52,
				dismissCallback = v53
			}),
			SearchBar = React.createElement(ContactListSearchBar, {
				layoutOrder = 2,
				searchBarHeight = 36,
				onSearchChanged = v54,
				searchText = v44,
				onFocused = v56
			}),
			ContentContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -88)
			}, v66)
		})
	end, {
		v46,
		v52,
		v53,
		v48,
		v42,
		v44
	})
	local t1 = {}

	if v42 then
		t1["ContactListContent" .. tostring(v40)] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v33),
			Position = UDim2.fromOffset(0, v33)
		}, { React.createElement(PeekView, {
			canDragFullViewToBrief = true,
			briefViewContentHeight = UDim.new(0.6, 0),
			closeSignal = v50.current,
			elasticBehavior = Enum.ElasticBehavior.Never,
			peekViewState = v48,
			viewStateChanged = v55
		}, {
			Content = v57
		}) })
	else
		t1.ContactListContent = v57
	end

	if v52 then
		return (React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = function() -- line: 353
				-- upvalues: v53 (copy)
				v53()
			end
		}, t1))
	end

	return nil
end

return ContactListContainer
