local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08

local AutoScroll = require(script.AutoScroll)
local ChatPreset = require(script.ChatPreset)
local PaginationEdges = require(script.PaginationEdges)
local ReachedThreshold = require(script.ReachedThreshold)

local InitialScrollPosition = require(script.InitialScrollPosition)
local ScrollPolicy = require(script.ScrollPolicy)

if FFlagViewRecyclerReact08 then
	AutoScroll = nil
end

if FFlagViewRecyclerReact08 then
	InitialScrollPosition = nil
end

if FFlagViewRecyclerReact08 then
	ScrollPolicy = nil
end

return {
	ChatPreset = ChatPreset,
	PaginationEdges = PaginationEdges,
	ReachedThreshold = ReachedThreshold,
	AutoScroll = AutoScroll,
	createInitialScrollPosition = InitialScrollPosition,
	createScrollPolicy = ScrollPolicy
}
