local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local UIBlox = require(AppChatParent.UIBlox)
local Foundation = require(AppChatParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local AssetCard = require(AppChat.Components.ChatConversation.AssetCardComponents.AssetCard)
local PlayButton = require(script.Parent.PlayButton)
local ViewDetailsButton = require(script.Parent.ViewDetailsButton)
local v11 = Roact.PureComponent:extend("GameCard")

v11.defaultProps = {
	isPlayButtonEnabled = true,
	playText = "Play",
	viewDetailsText = "View Details",
	noDescriptionText = "Placeholder: No Description",
	gameName = nil,
	gameIcon = nil,
	gameDescription = nil,
	contentLoadedCallback = nil,
	bodyActivated = nil,
	playabilityStatus = nil,
	conversationId = nil,
	universeId = nil,
	placeId = nil,
	price = nil,
	eventStream = nil,
	playButtonActivated = nil,
	viewDetailsActivated = nil,
	viewDetailsEnabled = true
}

function v11.makeButtons(p1, _) -- line: 64
	-- upvalues: Roact (copy), Skeleton (copy), EnumsRadius (copy), PlayButton (copy), ViewDetailsButton (copy)
	if not p1.props.playabilityStatus then
		return
	end

	local isPlayable = p1.props.playabilityStatus.isPlayable

	if p1.props.isLoading then
		return {
			loading = Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, 32),
				radius = EnumsRadius.Small
			})
		}
	end

	if p1.props.isPlayButtonEnabled and isPlayable == true then
		return {
			playButton = Roact.createElement(PlayButton, {
				placeId = p1.props.placeId,
				universeId = p1.props.universeId,
				text = p1.props.playText,
				conversationId = p1.props.conversationId,
				onActivated = function() -- line: 88
					-- upvalues: p1 (copy)
					p1.props.onPlayButtonActivated(p1.props)
				end,
				eventStream = p1.props.eventStream
			})
		}
	end

	if p1.props.viewDetailsEnabled then
		return {
			viewDetails = Roact.createElement(ViewDetailsButton, {
				text = p1.props.viewDetailsText,
				onActivated = function() -- line: 100
					-- upvalues: p1 (copy)
					p1.props.openDetails(p1.props)
				end,
				eventStream = p1.props.eventStream
			})
		}
	end
end
function v11.render(p3) -- line: 110
	-- upvalues: UIBlox (copy), Roact (copy), AssetCard (copy)
	return UIBlox.Style.withStyle(function(p4) -- line: 111
		-- upvalues: p3 (copy), Roact (copy), AssetCard (copy)
		if p3.props.universeId then
			local v17 = nil

			if p3.props.gameDescription then
				v17 = p3.props.gameDescription:gsub("%s", " ")

				if v17:gsub("^%s+$", "") == "" then
					v17 = p3.props.noDescriptionText
				end
			end

			return Roact.createElement(AssetCard, {
				isLoading = p3.props.isLoading,
				cardTitle = p3.props.gameName,
				cardBodyText = v17,
				cardIcon = p3.props.gameIcon,
				contentLoadedCallback = p3.props.contentLoadedCallback,
				bodyActivated = function() -- line: 131
					-- upvalues: p3 (copy)
					if p3.props.viewDetailsEnabled then
						p3.props.openDetails(p3.props)
					end
				end
			}, p3:makeButtons(p4))
		end

		return Roact.createElement(AssetCard, {
			isLoading = true,
			cardTitle = p3.props.gameName or "",
			cardBodyText = p3.props.gameDescription or "",
			cardIcon = p3.props.gameIcon or ""
		}, {
			fill = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 32)
			})
		})
	end)
end

return v11
