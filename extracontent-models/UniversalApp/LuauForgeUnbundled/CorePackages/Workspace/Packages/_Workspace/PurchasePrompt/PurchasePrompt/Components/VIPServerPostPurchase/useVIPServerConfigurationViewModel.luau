local ContextActionService = game:GetService("ContextActionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Localization").Hooks.useLocalization

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerConfigurationView")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function trim(value)
	return value:match("^%s*(.-)%s*$")
end

local function getOtherPlayers(players)
	local otherPlayers = {}

	for k, v5 in players:GetPlayers() do
		if v5 ~= players.LocalPlayer then
			table.insert(otherPlayers, v5)
		end
	end

	return otherPlayers
end

local function useVIPServerConfigurationViewModel(data)
	local v5 = useLocalization({
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

	local v6, v7 = React.useBinding(data.defaultServerName)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState({})
	local state5, setState5 = React.useState(nil)

	local v8, v9 = React.useBinding("")
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

				for k, item in items do
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
	local match = state:match("^%s*(.-)%s*$")

	local v10 = (utf8.len(match) or 0) >= 3

	React.useEffect(function()
		if not v10 then
			setState4({})
			return nil
		end

		local flag = true
		local thread = task.delay(0.3, function()
			data.searchUsers(match):andThen(function(p2)
				if flag then
					setState4(p2)
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
	end, { match, v10, data.searchUsers })

	local v11 = React.useCallback(function(p2, p3)
		setState3(function(p4)
			local clone = table.clone(p4)

			if p3 then
				clone[p2] = p3
				return clone
			end

			clone[p2] = nil

			return clone
		end)
	end, {})

	local v12 = React.useMemo(function()
		local result = {}

		for k, v13 in state10 do
			local userId = v13.UserId
			local displayName = v13.DisplayName
			local v14 = state3[userId] ~= nil
			table.insert(result, {
				userId = userId,
				displayName = displayName,
				isAdded = v14,
				onToggleAdded = function()
					v11(userId, if not v14 then displayName else nil)
				end
			})
		end

		return result
	end, { state10, state3, v11 })

	local userId = data.players.LocalPlayer.UserId
	local v13 = React.useMemo(function()
		local result = {}

		if not v10 then
			return result
		end

		for k, v14 in state4 do
			if v14.userId ~= userId and state3[v14.userId] == nil then
				table.insert(result, {
					userId = v14.userId,
					displayName = v14.displayName,
					onSelected = function()
						v11(v14.userId, v14.displayName)
						setState("")
					end
				})
			end
		end

		return result
	end, { v10, state4, state3, userId, v11 })

	local v14 = React.useMemo(function()
		local result = {}

		for k, v15 in state3 do
			table.insert(result, {
				userId = k,
				displayName = v15,
				onRemove = function()
					v11(k, nil)
				end
			})
		end

		table.sort(result, function(a, b): boolean
			return a.displayName < b.displayName
		end)

		return result
	end, { state3, v11 })

	local v15 = React.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true
		setState6(true)
		setState9(false)

		data.generateLink():andThen(function(p2)
			if ref4.current then
				setState5(p2)
				v9(p2)
				setState6(false)
			end
		end):catch(function()
			ref2.current = false

			if ref4.current then
				setState6(false)
				setState9(true)
			end
		end)
	end, { data.generateLink, v9 })

	local v16 = React.useCallback(function(p2)
		if state5 ~= nil and p2 ~= state5 then
			v9(state5)
		end
	end, { state5, v9 })

	local v17 = React.useCallback(function()
		if state5 == nil then
			return
		end

		default:setClipboardText({
			context = "PurchasePromptVIPServerLink",
			text = state5
		})

		setState7(true)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState7(false)
		end)
	end, { state5 })

	local v18 = React.useCallback(function()
		if ref3.current then
			return
		end

		ref3.current = true
		setState8(true)
		setState9(false)
		local match2 = v6:getValue():match("^%s*(.-)%s*$")
		local v19 = {}

		for k in state3 do
			table.insert(v19, k)
		end

		local save = data.save

		if match2 == "" or match2 == data.defaultServerName then
			match2 = nil
		end

		save({ name = match2, friendsAllowed = state2, usersToAdd = v19 }):andThen(function()
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
	end, { v6, state3, state2, data.save, data.onSaved, data.defaultServerName })

	local v19 = React.useCallback(function()
		if not ref3.current then
			data.onClose()
		end
	end, { data.onClose })

	local ref5 = React.useRef(v19)
	ref5.current = v19

	React.useEffect(function()
		ContextActionService:BindCoreAction("VIPServerConfigurationCancelButtonBind", function(p2, p3)
			if p3 == Enum.UserInputState.Begin then
				ref5.current()
			end
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("VIPServerConfigurationCancelButtonBind")
		end
	end, {})

	return {
		locales = v5,
		serverName = v6,
		onServerNameChanged = v7,
		searchText = state,
		onSearchTextChanged = setState,
		searchResults = v13,
		players = v12,
		addedPlayers = v14,
		friendsAllowed = state2,
		onFriendsAllowedChanged = setState2,
		link = state5,
		linkText = v8,
		onLinkTextChanged = v16,
		isGeneratingLink = state6,
		onGenerateLink = v15,
		onCopyLink = v17,
		isLinkCopied = state7,
		hasError = state9,
		isSaving = state8,
		onSave = v18,
		onCancel = v19
	}
end

return useVIPServerConfigurationViewModel
