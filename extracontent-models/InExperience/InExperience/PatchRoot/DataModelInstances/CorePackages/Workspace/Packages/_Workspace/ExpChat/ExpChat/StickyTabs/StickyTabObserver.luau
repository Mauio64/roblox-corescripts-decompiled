local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local TextChatService = game:GetService("TextChatService")

local Signals = require(parent.Signals)
require(parent.ExpChatShared)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)
require(script.Parent.StickyTabsStore)
local selectTabByType = require(ExpChat.TabNavigation.selectTabByType)
local hasUserSelectedTab = require(ExpChat.mountClientApp.helpers.hasUserSelectedTab)

local defineFastInt = game:DefineFastInt("ExpChatStickyTabTimeLimitSeconds", 10)

local StickyTabObserver = {}

local v = nil
local fn = nil
local targetTextChannelChangedConnection = nil
local v2 = nil

local lastTime = 0

local function isCustomChannel(tabName: string): boolean -- 1 equivalent call inferred from this helper
	return tabName ~= "RBXGeneral" and tabName ~= "RBXGlobal" and tabName ~= FriendsChatTabName
end

local function save(selectedTabName: string) -- 3 equivalent calls inferred from this helper
	local gameId = game.GameId
	perUserAppStorage.updateEntry("ExpChatStickyTab", function(p)
		if p.tabName == selectedTabName and p.experienceId == gameId then
			return nil
		end

		return { tabName = selectedTabName, experienceId = gameId }
	end)
end

local function getTabType(p: string): string -- 1 equivalent call inferred from this helper
	if p == "RBXGlobal" then
		return "UniverseChat"
	end

	return if p == FriendsChatTabName then "FriendsChat" else "TextChat"
end

local function getAllChannelTabs(object) -- 3 equivalent calls inferred from this helper
	if FFlagExpChatUseChannelTabsStore then
		return GetChannelTabsStore(false).getChannelTabsState(false).allChannelTabs
	end

	return object:getState().ChannelTabs.allChannelTabs
end

local function getStickyTab(p) -- 1 equivalent call inferred from this helper
	if type(p) ~= "table" then
		return nil
	end

	local tabName = p.tabName

	if type(tabName) ~= "string" or isCustomChannel(tabName) and p.experienceId ~= game.GameId then -- inferred equivalent call
		return nil
	end

	return tabName
end

local function watchForTabChanges(object)
	if FFlagExpChatUseChannelTabsStore then
		local channelTabsStore = GetChannelTabsStore(false)
		local effect = Signals.createEffect(function(p)
			local selectedTabName = channelTabsStore.getSelectedTabName(p)

			if selectedTabName ~= nil then
				save(selectedTabName) -- inferred equivalent call
			end
		end)

		channelTabsStore.setOnChannelTabAdded(function(p)
			StickyTabObserver:goToStickyTab(p)
		end)
		fn = function()
			effect()
			channelTabsStore.setOnChannelTabAdded(nil)
		end
	else
		local changedConnection = object.changed:connect(function(p, p2)
			local selectedTabName = p.ChannelTabs.selectedTabName

			if selectedTabName ~= nil and selectedTabName ~= p2.ChannelTabs.selectedTabName then
				save(selectedTabName) -- inferred equivalent call
			end
		end)
		fn = function()
			changedConnection:disconnect()
		end

		local selectedTabName = object:getState().ChannelTabs.selectedTabName

		if selectedTabName ~= nil then
			save(selectedTabName) -- inferred equivalent call
		end
	end
end

local function watchForDeveloperDefault()
	local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

	if chatInputBarConfiguration == nil then
		return
	end

	local function onTargetChanged() -- 1 equivalent call inferred from this helper
		local targetTextChannel = chatInputBarConfiguration.TargetTextChannel

		if targetTextChannel and targetTextChannel.Name ~= "RBXGeneral" and targetTextChannel.Name ~= v2 then
			v2 = nil
		end
	end

	onTargetChanged() -- inferred equivalent call
	targetTextChannelChangedConnection = chatInputBarConfiguration:GetPropertyChangedSignal("TargetTextChannel"):Connect(onTargetChanged)
end

function StickyTabObserver:start(object)
	self:stop()
	v = object
	lastTime = os.clock()

	v2 = getStickyTab(perUserAppStorage.getEntry("ExpChatStickyTab")) -- inferred equivalent call

	watchForTabChanges(object)
	watchForDeveloperDefault()

	local v3 = v2

	if v3 ~= nil and getAllChannelTabs(object)[v3] then -- inferred equivalent call
		self:goToStickyTab(v3)
	end
end

function StickyTabObserver:goToStickyTab(channelName: string)
	if channelName ~= v2 then
		return
	end

	local v3 = v

	if v3 ~= nil and getAllChannelTabs(v3)[channelName] then -- inferred equivalent call
		if defineFastInt < os.clock() - lastTime or hasUserSelectedTab(v3) then
			v2 = nil
		else
			task.defer(function()
				if v ~= v3 or v2 ~= channelName then
					return
				end

				v2 = nil

				if not hasUserSelectedTab(v3) and getAllChannelTabs(v3)[channelName] then -- inferred equivalent call
					local function fn2(p)
						return v3:dispatch(p)
					end

					selectTabByType(fn2, {
						channelName = channelName,
						tabType = getTabType(channelName), -- inferred equivalent call
						shouldReorderTabs = false,
						textChannel = v3:getState().TextChannels.allTextChannels[channelName]
					})
				end
			end)
		end
	end
end

function StickyTabObserver:stop()
	v2 = nil
	v = nil

	if targetTextChannelChangedConnection then
		targetTextChannelChangedConnection:Disconnect()
		targetTextChannelChangedConnection = nil
	end

	local v3 = fn

	if v3 then
		fn = nil
		v3()
	end
end

return StickyTabObserver
