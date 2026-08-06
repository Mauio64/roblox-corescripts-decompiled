local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Config = require(ExpChat.Config)
local React = require(ExpChatParent.React)
local ReactFocusNavigation = require(ExpChatParent.ReactFocusNavigation)
local SignalsReact = require(ExpChatParent.SignalsReact)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local UIBlox = require(ExpChatParent.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local FFlagExpChatFocusChannelBarSupport = require(ExpChat.Flags.FFlagExpChatFocusChannelBarSupport)
local FFlagExpChatChannelBarDropdownZIndexFix = require(ExpChat.Flags.FFlagExpChatChannelBarDropdownZIndexFix)
local v17 = require(ExpChat.Stores.GetFocusNavigationStore)(false)
local FFlagExpChatPerfTracking = require(ExpChatParent.SharedFlags).FFlagExpChatPerfTracking
local FFlagExpChatChannelTabRefactor = require(ExpChatParent.SharedFlags).FFlagExpChatChannelTabRefactor
local FFlagExpChatEnableFriendsTab = require(ExpChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local FFlagExpChatPerfTrackerTabName = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatPerfTrackerTabName
local ChannelTab = require(script.Parent.Parent.ChannelTab)
local v25 = Images["icons/navigation/cycleDown"]
local color3 = Color3.fromRGB(255, 255, 255)
local color3_2 = Color3.fromRGB(100, 100, 100)

local function countAllChannelTabs(p1) -- line: 75
	local n1 = 0

	for _ in pairs(p1) do
		n1 += 1
	end

	return n1
end
local function setTransparency(p2, p3) -- line: 83
	return p3:map(function(p4) -- line: 84
		-- upvalues: p2 (copy)
		if p2 == nil then
			return 1
		end

		return p2 + p4 * (1 - p2)
	end)
end
local function ChannelBar(t1: {[any]: any}) -- line: 89
	-- upvalues: Config (copy), React (copy), FFlagExpChatFocusChannelBarSupport (copy), SignalsReact (copy), v17 (copy), ReactFocusNavigation (copy), useSelectionCursor (copy), CursorKind (copy), FFlagExpChatEnableFriendsTab (copy), FFlagExpChatChannelTabRefactor (copy), ChannelTab (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatPerfTrackerTabName (copy), setTransparency (copy), TextChatService (copy), useInterpolatedClientSettings (copy), FFlagExpChatChannelBarDropdownZIndexFix (copy), color3_2 (copy), ImageSetLabel (copy), v25 (copy), color3 (copy)
	local allChannelTabs = t1.allChannelTabs
	local n2 = 0

	for _ in pairs(allChannelTabs) do
		n2 += 1
	end

	local v40 = Config.ChatWindowSize.Y.Scale * t1.chatWindowSettings.HeightScale * Config.ChatWindowMaxWidth
	local v41, v42 = React.useState(false)
	local v43, v44 = React.useState(false)
	local v45, v46 = React.useState(1024)
	local v47 = if not FFlagExpChatFocusChannelBarSupport then nil else SignalsReact.useSignalState(v17.getChatInputBarFocused)
	local v48 = if not FFlagExpChatFocusChannelBarSupport then nil else React.useRef(nil)
	local v49 = if not FFlagExpChatFocusChannelBarSupport then nil else ReactFocusNavigation.useFocusGuiObject()
	local v50 = if not FFlagExpChatFocusChannelBarSupport then nil else useSelectionCursor(CursorKind.Invisible)
	local v51 = if not FFlagExpChatFocusChannelBarSupport then nil else useSelectionCursor(CursorKind.RoundedSlot)
	local v52 = v45 < n2 * Config.ChannelTabsSettings.MinTabWidth
	local v53 = not v52 and n2 or math.floor((v45 - Config.ChannelTabsSettings.DropdownIconContainerWidth) / Config.ChannelTabsSettings.MinTabWidth)
	local v54 = (v45 - (v52 and Config.ChannelTabsSettings.DropdownIconContainerWidth or 0)) / v53
	local v55 = (n2 - v53) * 40
	local v56 = React.useMemo(function() -- line: 121
		-- upvalues: t1 (copy), v53 (copy)
		for _, v in pairs(t1.allChannelTabs) do
			if v.TabIndex > v53 and v.HasUnreadMessages then
				return true
			end
		end

		return false
	end, if not FFlagExpChatEnableFriendsTab then nil else {
		v53,
		t1.allChannelTabs
	})
	local t2 = {
		["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal
		})
	}
	local t3 = {
		["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
	}

	for k, v in pairs(t1.allChannelTabs) do
		local v61 = v53 >= v.TabIndex
		local v62 = t1.allTextChannels[k]
		local v63 = if not FFlagExpChatChannelTabRefactor then nil else v.Type
		local v64 = React.createElement(ChannelTab, {
			channelTabsSettings = t1.channelTabsSettings,
			channelName = k,
			textChannel = v62,
			tabType = v63,
			hasUnreadMessages = v.HasUnreadMessages,
			isDividerVisible = (v53 > v.TabIndex or v52) and n2 > v.TabIndex,
			isTabCollapsed = not v61,
			isTabSelected = t1.selectedTabName and k == t1.selectedTabName,
			onTabSelected = function() -- line: 160
				-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatChannelTabRefactor (copy), k (copy), v62 (copy), FFlagExpChatPerfTrackerTabName (copy), v61 (copy), v47 (copy), v48 (copy), v49 (copy), t1 (copy), v63 (copy), v44 (copy)
				if FFlagExpChatPerfTracking then
					ExpChatPerfTracker.cancelAll()
					ExpChatPerfTracker.start(ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI, {
						tabId = if not GetFFlagTextChatEnableUniverseChatTabs() and not FFlagExpChatChannelTabRefactor then if not v62 then nil else v62.Name else k
					}, if not FFlagExpChatPerfTrackerTabName then nil else {
						tabName = k
					})
				end

				if not v61 and v47 and v48.current then
					v49(v48.current)
				end

				t1.onTabSelected(v62, not v61, k, v63)
				v44(false)
			end,
			setTransparency = function(p5) -- line: 177
				-- upvalues: setTransparency (copy), t1 (copy)
				return setTransparency(p5, t1.transparencyValue)
			end
		})

		if v61 then
			t2[v.TabIndex] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v54, 1, 0),
				LayoutOrder = v.TabIndex
			}, {
				ChannelTab = v64
			})
		else
			local v65 = v.TabIndex - v53

			t3[v65] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				LayoutOrder = v65
			}, {
				ChannelTab = v64
			})
		end
	end

	local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
	local channelTabsSettings = t1.channelTabsSettings
	local BackgroundTransparency = useInterpolatedClientSettings(channelTabsSettings).BackgroundTransparency
	local BackgroundColor3 = useInterpolatedClientSettings(channelTabsSettings).BackgroundColor3
	local createElement = React.createElement
	local t4 = {
		Size = UDim2.new(1, 0, 0, Config.ChannelTabsSettings.HorizontalBarHeight),
		BackgroundTransparency = 1,
		Visible = t1.visible,
		BorderSizePixel = 0,
		ZIndex = if not FFlagExpChatChannelBarDropdownZIndexFix then nil else 3,
		[React.Event.MouseEnter] = t1.onHovered,
		[React.Event.MouseLeave] = t1.onUnhovered,
		[React.Change.AbsoluteSize] = function(p6) -- line: 215
			-- upvalues: v46 (copy), ChannelTabsConfiguration (copy)
			v46(p6.AbsoluteSize.X)

			if ChannelTabsConfiguration then
				ChannelTabsConfiguration:SetAbsoluteSize(p6.AbsoluteSize)
			end
		end,
		[React.Change.AbsolutePosition] = function(p7) -- line: 221
			-- upvalues: ChannelTabsConfiguration (copy)
			if ChannelTabsConfiguration then
				ChannelTabsConfiguration:SetAbsolutePosition(p7.AbsolutePosition)
			end
		end
	}
	local t5 = {}
	local createElement2 = React.createElement
	local t6 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}
	local t7 = {
		ContentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, t2),
		TopCorner = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
			BorderSizePixel = 0,
			ImageColor3 = BackgroundColor3,
			ImageTransparency = t1.transparencyValue:map(function(p8) -- line: 84
				-- upvalues: BackgroundTransparency (copy)
				if BackgroundTransparency == nil then
					return 1
				end

				return BackgroundTransparency + p8 * (1 - BackgroundTransparency)
			end),
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 8),
			SliceCenter = Rect.new(8, 8, 24, 32),
			Selectable = not not FFlagExpChatFocusChannelBarSupport or nil,
			SelectionImageObject = v50,
			ref = if not FFlagExpChatFocusChannelBarSupport then nil else t1.topBorderRef
		})
	}
	local createElement3 = React.createElement
	local t8 = {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Config.ChannelTabsSettings.BorderColor3
	}
	local BorderTransparency = Config.ChannelTabsSettings.BorderTransparency

	t8.BackgroundTransparency = t1.transparencyValue:map(function(p9) -- line: 84
		-- upvalues: BorderTransparency (copy)
		if BorderTransparency == nil then
			return 1
		end

		return BorderTransparency + p9 * (1 - BorderTransparency)
	end)
	t7.BottomBorder = createElement3("Frame", t8)
	t7.Background = React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, Config.ChannelTabsSettings.HorizontalBarHeight - 8 - 1),
		Position = UDim2.new(0, 0, 0, 8),
		BackgroundColor3 = BackgroundColor3,
		BackgroundTransparency = t1.transparencyValue:map(function(p10) -- line: 84
			-- upvalues: BackgroundTransparency (copy)
			if BackgroundTransparency == nil then
				return 1
			end

			return BackgroundTransparency + p10 * (1 - BackgroundTransparency)
		end)
	})
	t5.HorizontalBar = createElement2("Frame", t6, t7)

	local v79 = v52

	if v79 then
		local createElement4 = React.createElement
		local t9 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 8),
			Size = UDim2.new(0, Config.ChannelTabsSettings.DropdownIconContainerWidth, 1, -9),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		}
		local t10 = {}
		local createElement5 = React.createElement
		local t11 = {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -Config.ChannelTabsSettings.DropdownIconPadding / 2, 0.5, -4),
			Size = UDim2.new(0, 27, 0, 27)
		}
		local v85 = not v41 and 1 or 0.3

		t11.BackgroundTransparency = t1.transparencyValue:map(function(p11) -- line: 84
			-- upvalues: v85 (copy)
			if v85 == nil then
				return 1
			end

			return v85 + p11 * (1 - v85)
		end)
		t11.BackgroundColor3 = color3_2
		t11.Text = ""
		t11.BorderSizePixel = 0
		t11.Selectable = not not FFlagExpChatFocusChannelBarSupport or nil
		t11.SelectionImageObject = v51
		t11.ref = if not FFlagExpChatFocusChannelBarSupport then nil else v48
		t11[React.Event.MouseEnter] = function() -- line: 297
			-- upvalues: v42 (copy)
			v42(true)
		end
		t11[React.Event.MouseLeave] = function() -- line: 300
			-- upvalues: v42 (copy)
			v42(false)
		end
		t11[React.Event.Activated] = function() -- line: 303
			-- upvalues: v44 (copy), v43 (copy)
			v44(not v43)
		end

		local t12 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 27)
			})
		}
		local createElement6 = React.createElement
		local v88 = ImageSetLabel
		local t13 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.6, 0.6),
			Image = v25,
			ImageColor3 = color3
		}
		local n3 = 0

		t13.ImageTransparency = t1.transparencyValue:map(function(p12) -- line: 84
			-- upvalues: n3 (copy)
			if n3 == nil then
				return 1
			end

			return n3 + p12 * (1 - n3)
		end)
		t13.ScaleType = Enum.ScaleType.Stretch
		t12.DropdownIconImage = createElement6(v88, t13)
		t10.TextButton = createElement5("TextButton", t11, t12)

		if v56 then
			local createElement7 = React.createElement
			local t14 = {
				BorderSizePixel = 0,
				Size = UDim2.new(0, 8, 0, 8),
				Position = UDim2.new(0, 18, 0.5, -4),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Config.ChannelTabsSettings.UnreadDotColor3
			}
			local n4 = 0

			t14.BackgroundTransparency = t1.transparencyValue:map(function(p13) -- line: 84
				-- upvalues: n4 (copy)
				if n4 == nil then
					return 1
				end

				return n4 + p13 * (1 - n4)
			end)
			v56 = createElement7("Frame", t14, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			})
		end

		t10.UnreadDot = v56
		v79 = createElement4("Frame", t9, t10)
	end

	t5.DropdownButton = v79

	if v52 then
		local createElement8 = React.createElement
		local t15 = {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -1, 0, Config.ChannelTabsSettings.HorizontalBarHeight + 1),
			Size = UDim2.new(0, 150, 0, v55),
			Visible = v43
		}
		local t16 = {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(150, v40)
			})
		}
		local createElement9 = React.createElement
		local t17 = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Config.ChannelTabsSettings.BorderColor3
		}
		local BorderTransparency2 = Config.ChannelTabsSettings.BorderTransparency

		t17.Transparency = t1.transparencyValue:map(function(p14) -- line: 84
			-- upvalues: BorderTransparency2 (copy)
			if BorderTransparency2 == nil then
				return 1
			end

			return BorderTransparency2 + p14 * (1 - BorderTransparency2)
		end)
		t16.Border = createElement9("UIStroke", t17)

		local createElement10 = React.createElement
		local t18 = {
			ScrollBarThickness = 4,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(0, 150, 0, v55)
		}
		local n5 = 0

		t18.BackgroundTransparency = t1.transparencyValue:map(function(p15) -- line: 84
			-- upvalues: n5 (copy)
			if n5 == nil then
				return 1
			end

			return n5 + p15 * (1 - n5)
		end)

		local n6 = 0

		t18.ScrollBarImageTransparency = t1.transparencyValue:map(function(p16) -- line: 84
			-- upvalues: n6 (copy)
			if n6 == nil then
				return 1
			end

			return n6 + p16 * (1 - n6)
		end)
		t18.ScrollingDirection = Enum.ScrollingDirection.Y
		t18.ElasticBehavior = Enum.ElasticBehavior.Always
		t18.Selectable = not FFlagExpChatFocusChannelBarSupport and nil
		t16.ScrollView = createElement10("ScrollingFrame", t18, t3)
		v52 = createElement8("Frame", t15, t16)
	end

	t5.DropdownMenu = v52

	return createElement("Frame", t4, t5)
end

return ChannelBar
