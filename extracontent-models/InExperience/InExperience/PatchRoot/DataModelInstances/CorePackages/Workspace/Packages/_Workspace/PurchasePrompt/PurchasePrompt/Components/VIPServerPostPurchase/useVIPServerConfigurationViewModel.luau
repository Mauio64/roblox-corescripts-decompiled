local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local ContextActionService = game:GetService("ContextActionService")

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

require(script.Parent.VIPServerConfigurationView)
require(PurchasePrompt.types)

local function trim(value: string) -- 2 equivalent calls inferred from this helper
	return (value:match("^%s*(.-)%s*$"))
end

local function getOtherPlayers(players)
	local otherPlayers = {}

	for _, v in players:GetPlayers() do
		if v ~= players.LocalPlayer then
			table.insert(otherPlayers, v)
		end
	end

	return otherPlayers
end

local function useVIPServerConfigurationViewModel(data)
	local locales = useLocalization({
		title = "Feature.PrivateServers.Heading.ConfigurePrivateServer",
		serverName = "Feature.PrivateServers.Label.ServerName",
		whoCanJoin = "Feature.PrivateServers.Label.WhoCanJoin",
		searchPeople = "Feature.PrivateServers.Label.SearchPeople",
		inThisServer = "Feature.PrivateServers.Label.InThisServer",
		noOne = "Feature.AccountSettings.Label.DropDown.NoOne",
		add = "CommonUI.Features.Label.Add",
		friendsAllowed = "Feature.PrivateServers.Label.FriendsAllowed",
		friendsAllowedDescription = "Feature.PrivateServers.Description.FriendsAllowed",
		privateServerLink = "Feature.PrivateServers.Label.PrivateServerLink",
		anyoneWithThisLinkCanJoin = "Feature.PrivateServers.Label.AnyoneWithThisLinkCanJoin",
		generate = "Feature.PrivateServers.Action.Generate",
		generateLinkPlaceholder = "Feature.PrivateServers.Label.PrivateServerGenerateLinkPlaceholder",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong",
		continue = "CommonUI.Controls.Action.Continue"
	})

	local serverName, onServerNameChanged = React.useBinding(data.defaultServerName)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState({})
	local state5, setState5 = React.useState(nil)

	local linkText, v = React.useBinding("")
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(false)
	local ref = React.useRef(nil)
	local state8, setState8 = React.useState(false)
	local state9, setState9 = React.useState(false)
	local state10, setState10 = React.useState(function()
		return getOtherPlayers(data.players)
	end)

	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(true)

	React.useEffect(function()
		ref4.current = true
		return function()
			ref4.current = false

			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	React.useEffect(function()
		local playerAddedConnection = data.players.PlayerAdded:Connect(function(player)
			setState10(function(list)
				if table.find(list, player) then
					return list
				end

				local clone = table.clone(list)
				table.insert(clone, player)
				return clone
			end)
		end)

		local playerRemovingConnection = data.players.PlayerRemoving:Connect(function(player)
			setState10(function(items)
				local result = {}

				for _, item in items do
					if item ~= player then
						table.insert(result, item)
					end
				end

				return result
			end)
		end)
		return function()
			playerAddedConnection:Disconnect()
			playerRemovingConnection:Disconnect()
		end
	end, { data.players })
	local v2 = trim(state) -- inferred equivalent call
	local v3 = (utf8.len(v2) or 0) >= 3

	React.useEffect(function()
		if not v3 then
			setState4({})
			return nil
		end

		local flag = true
		local thread = task.delay(0.3, function()
			data.searchUsers(v2):andThen(function(p)
				if flag then
					setState4(p)
				end
			end):catch(function()
				if flag then
					setState4({})
				end
			end)
		end)
		return function()
			flag = false
			task.cancel(thread)
		end
	end, { v2, v3, data.searchUsers })

	local v4 = React.useCallback(function(p: number, p2: string?)
		setState3(function(p3)
			local clone = table.clone(p3)

			if p2 then
				clone[p] = p2
				return clone
			end

			clone[p] = nil

			return clone
		end)
	end, {})

	local players = React.useMemo(function()
		local result = {}

		for _, v5 in state10 do
			local userId = v5.UserId
			local displayName = v5.DisplayName
			local isAdded = state3[userId] ~= nil
			table.insert(result, {
				userId = userId,
				displayName = displayName,
				isAdded = isAdded,
				onToggleAdded = function()
					local v6

					if not isAdded then
						v6 = displayName
					end

					v4(userId, v6)
				end
			})
		end

		return result
	end, { state10, state3, v4 })

	local userId = data.players.LocalPlayer.UserId
	local searchResults = React.useMemo(function()
		local result = {}

		if not v3 then
			return result
		end

		for _, v5 in state4 do
			if v5.userId ~= userId and state3[v5.userId] == nil then
				table.insert(result, {
					userId = v5.userId,
					displayName = v5.displayName,
					onSelected = function()
						v4(v5.userId, v5.displayName)
						setState("")
					end
				})
			end
		end

		return result
	end, { v3, state4, state3, userId, v4 })

	local addedPlayers = React.useMemo(function()
		local result = {}

		for k, displayName in state3 do
			table.insert(result, {
				userId = k,
				displayName = displayName,
				onRemove = function()
					v4(k, nil)
				end
			})
		end

		table.sort(result, function(a, b): boolean
			return a.displayName < b.displayName
		end)

		return result
	end, { state3, v4 })

	local onGenerateLink = React.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true
		setState6(true)
		setState9(false)

		data.generateLink():andThen(function(p: string)
			if ref4.current then
				setState5(p)
				v(p)
				setState6(false)
			end
		end):catch(function()
			ref2.current = false

			if ref4.current then
				setState6(false)
				setState9(true)
			end
		end)
	end, { data.generateLink, v })

	local onLinkTextChanged = React.useCallback(function(p: string)
		if state5 ~= nil and p ~= state5 then
			v(state5)
		end
	end, { state5, v })

	local onCopyLink = React.useCallback(function()
		if state5 == nil then
			return
		end

		default:setClipboardText({ context = "PurchasePromptVIPServerLink", text = state5 })

		setState7(true)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState7(false)
		end)
	end, { state5 })

	local onSave = React.useCallback(function()
		if ref3.current then
			return
		end

		ref3.current = true
		setState8(true)
		setState9(false)

		local name = trim(serverName:getValue()) -- inferred equivalent call
		local usersToAdd = {}

		for k in state3 do
			table.insert(usersToAdd, k)
		end

		local save = data.save

		if name == "" or name == data.defaultServerName then
			name = nil
		end

		save({ name = name, friendsAllowed = state2, usersToAdd = usersToAdd }):andThen(function()
			if ref4.current then
				data.onSaved()
			end
		end):catch(function()
			ref3.current = false

			if ref4.current then
				setState8(false)
				setState9(true)
			end
		end)
	end, { serverName, state3, state2, data.save, data.onSaved, data.defaultServerName })

	local v5 = React.useCallback(function()
		if not ref3.current then
			data.onClose()
		end
	end, { data.onClose })

	local ref5 = React.useRef(v5)
	ref5.current = v5

	React.useEffect(function()
		ContextActionService:BindCoreAction("VIPServerConfigurationCancelButtonBind", function(_, p)
			if p == Enum.UserInputState.Begin then
				ref5.current()
			end
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("VIPServerConfigurationCancelButtonBind")
		end
	end, {})

	return {
		locales = locales,
		serverName = serverName,
		onServerNameChanged = onServerNameChanged,
		searchText = state,
		onSearchTextChanged = setState,
		searchResults = searchResults,
		players = players,
		addedPlayers = addedPlayers,
		friendsAllowed = state2,
		onFriendsAllowedChanged = setState2,
		link = state5,
		linkText = linkText,
		onLinkTextChanged = onLinkTextChanged,
		isGeneratingLink = state6,
		onGenerateLink = onGenerateLink,
		onCopyLink = onCopyLink,
		isLinkCopied = state7,
		hasError = state9,
		isSaving = state8,
		onSave = onSave,
		onCancel = v5
	}
end

return useVIPServerConfigurationViewModel
