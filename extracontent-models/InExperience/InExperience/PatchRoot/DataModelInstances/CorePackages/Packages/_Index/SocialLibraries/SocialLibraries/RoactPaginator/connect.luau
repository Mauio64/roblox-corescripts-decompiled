local RoactPaginator = script:FindFirstAncestor("RoactPaginator")
local fetchInitSymbol = require(RoactPaginator.fetchInitSymbol)
local fetchWithCursorSymbol = require(RoactPaginator.fetchWithCursorSymbol)
local loadNextSymbol = require(RoactPaginator.loadNextSymbol)
local loadPreviousSymbol = require(RoactPaginator.loadPreviousSymbol)
local Logger = require(RoactPaginator.Logger)

local dependencies = require(RoactPaginator.Parent.dependencies)
local roact = dependencies.Roact
local cryo = dependencies.Cryo
local genericPagination = dependencies.GenericPagination

local function formatMessage(list, options) -- 1 equivalent call inferred from this helper
	return table.concat(list, "\n"):format(unpack(options or {}))
end

local function connect(callback)
	assert(callback and type(callback) == "function", "RoactPaginator.connect: parameters expected to be a function")
	local traceback = debug.traceback()

	return function(p)
		if p == nil then
			error(
				formatMessage( -- inferred equivalent call
					{ "connect returns a function that must be passed a component.", "Check the connection at:", "%s" },
					{ traceback }
				),
				2
			)
		end

		local formatted = ("PaginatorConnection(%s)"):format((tostring(p)))

		local extended = roact.Component:extend(formatted)

		function extended:init()
			local v = callback()
			assert(v, "RoactPaginator.connect: Expected parameters to return an object")

			self.paginator = genericPagination.new({
				pageSize = v.pageSize,
				fetchInit = self.props[fetchInitSymbol],
				fetchWithCursor = self.props[fetchWithCursorSymbol]
			})
		end

		function extended.render(p2)
			local joined = cryo.Dictionary.join(p2.props, {
				[loadNextSymbol] = function()
					if p2.paginator:isFetching() then
						return
					end

					p2.paginator:getNext():catch(function(p3)
						Logger:error("Could not getNext. Got error: {}", p3)
					end)
				end,
				[loadPreviousSymbol] = function()
					if p2.paginator:isFetching() then
						return
					end

					p2.paginator:getPrevious():catch(function(p3)
						Logger:error("Could not getPrevious. Got error: {}", p3)
					end)
				end
			})

			return roact.createElement(p, joined)
		end

		return extended
	end
end

return connect
