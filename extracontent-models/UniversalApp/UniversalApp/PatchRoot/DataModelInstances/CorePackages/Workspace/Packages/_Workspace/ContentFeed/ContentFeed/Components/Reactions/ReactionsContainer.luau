local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local React = require(ParentParentParent.React)
local ReactCTA = require(ParentParent.Components.Reactions.ReactCTA)
local ReactionIconMappings = require(ParentParent.Constants).ReactionIconMappings
local ReactionPicker = require(ParentParent.Components.Reactions.ReactionPicker)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function ReactionsContainer(t1: {[any]: any}) -- line: 27
	-- upvalues: useSelector (copy), getDeepValue (copy), React (copy), Popover (copy), ReactCTA (copy), ReactionIconMappings (copy), PopoverSide (copy), PopoverAlign (copy), ReactionPicker (copy)
	local v17 = useSelector(function(p1) -- line: 28
		-- upvalues: getDeepValue (copy), t1 (copy)
		local v23 = getDeepValue(p1, "ContentSharing.byUserId." .. t1.creatorUserId .. ".reactionsByPostId")

		if not v23 or not v23[t1.postId] then
			return nil
		end

		return v23[t1.postId].viewerUserReactedToEmoteId
	end)
	local v18, v19 = React.useState(false)
	local v20 = React.useCallback(function(_) -- line: 39
		-- upvalues: v19 (copy)
		v19(false)
	end, { v19 })
	local v21 = React.useCallback(function() -- line: 44
	end, {})

	return React.createElement(Popover.Root, {
		LayoutOrder = t1.layoutOrder,
		isOpen = v18
	}, {
		Anchor = React.createElement(Popover.Anchor, {}, {
			ReactCTA = React.createElement(ReactCTA, {
				onShortPress = v21,
				onLongPress = function() -- line: 55
					-- upvalues: v19 (copy)
					v19(true)
				end,
				activeReaction = if not v17 then nil else ReactionIconMappings[v17]
			})
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				offset = 20,
				position = PopoverSide.Top
			},
			align = PopoverAlign.End,
			onPressedOutside = function() -- line: 69
				-- upvalues: v19 (copy)
				v19(false)
			end
		}, {
			ReactionPicker = React.createElement(ReactionPicker, {
				reactToContent = v20
			})
		})
	})
end

return ReactionsContainer
