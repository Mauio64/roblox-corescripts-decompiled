local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08

local AutoScroll = require(script.AutoScroll)
local ChatPreset = require(script.ChatPreset)
local PaginationEdges = require(script.PaginationEdges)
local ReachedThreshold = require(script.ReachedThreshold)

local InitialScrollPosition = require(script.InitialScrollPosition)
local ScrollPolicy = require(script.ScrollPolicy)

if FFlagViewRecyclerReact084 then
	AutoScroll = nil
elseif FFlagViewRecyclerReact08 then
	AutoScroll = nil
end

if FFlagViewRecyclerReact084 then
	InitialScrollPosition = nil
elseif FFlagViewRecyclerReact08 then
	InitialScrollPosition = nil
end

if FFlagViewRecyclerReact084 then
	ScrollPolicy = nil
elseif FFlagViewRecyclerReact08 then
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
