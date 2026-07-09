local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local memoize = dependencies.memoize
local User = require(SocialTab.User)
local FreeFlowCarousel = UIBlox.App.Container.Carousel.FreeFlowCarousel
local AddFriendHint = require(script.Parent.AddFriendHint)
local v10 = Roact.PureComponent:extend("UIBloxCarouselAdaptor")

v10.defaultProps = {
	friendThumbnailSize = 96,
	LayoutOrder = 0,
	wideMode = false,
	tileHeight = 96,
	friends = {}
}
v10.validateProps = t.interface({
	createUserEntry = t.callback,
	friends = t.array(User.validateUser),
	friendThumbnailSize = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	onFriendSelected = t.optional(t.callback),
	wideMode = t.optional(t.boolean)
})

function v10.init(p1) -- line: 39
	-- upvalues: Roact (copy), AddFriendHint (copy), memoize (copy)
	function p1.identifier(p2) -- line: 40
		return p2.absolutePosition
	end
	function p1.createUserEntry(p3) -- line: 44
		-- upvalues: Roact (copy), AddFriendHint (copy), p1 (copy)
		if p3.absolutePosition == 2 and p3.addFriendHint then
			return Roact.createElement(AddFriendHint, {
				layoutOrder = 2,
				maxHintHeight = p1.props.friendThumbnailSize
			})
		end

		if p3.absolutePosition > 0 and p3.isPlaceHolder == true then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p1.props.friendThumbnailSize, 1, 0)
			})
		end

		return p1.props.createUserEntry(p3)
	end

	p1.formatFriends = memoize(function(p4) -- line: 61
		local t1 = {}

		table.insert(t1, {
			absolutePosition = 1
		})

		if #p4 == 0 then
			table.insert(t1, {
				absolutePosition = 2,
				addFriendHint = true
			})
		end

		for i, v in ipairs(p4) do
			table.insert(t1, {
				layoutOrder = i + 1,
				absolutePosition = i + 1,
				user = v
			})
		end

		return t1
	end)
end
function v10.render(p5) -- line: 85
	-- upvalues: Roact (copy), FreeFlowCarousel (copy)
	local v13 = not p5.props.wideMode and 24 or 48

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = p5.props.LayoutOrder,
		Size = UDim2.new(1, v13, 0, p5.props.tileHeight + 18)
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -v13),
			PaddingTop = UDim.new(0, -38)
		}),
		CarouselContent = Roact.createElement(FreeFlowCarousel, {
			identifier = p5.identifier,
			itemList = p5.formatFriends(p5.props.friends),
			renderItem = p5.createUserEntry,
			itemSize = Vector2.new(p5.props.friendThumbnailSize, p5.props.tileHeight + 18),
			carouselMargin = v13
		})
	})
end

return v10
