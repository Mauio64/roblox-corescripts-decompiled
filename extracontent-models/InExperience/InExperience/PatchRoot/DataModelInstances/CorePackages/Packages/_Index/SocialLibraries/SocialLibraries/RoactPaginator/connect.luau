local RoactPaginator = script:FindFirstAncestor("RoactPaginator")
local fetchInitSymbol = require(RoactPaginator.fetchInitSymbol)
local fetchWithCursorSymbol = require(RoactPaginator.fetchWithCursorSymbol)
local loadNextSymbol = require(RoactPaginator.loadNextSymbol)
local loadPreviousSymbol = require(RoactPaginator.loadPreviousSymbol)
local Logger = require(RoactPaginator.Logger)
local dependencies = require(RoactPaginator.Parent.dependencies)
local Roact = dependencies.Roact
local Cryo = dependencies.Cryo
local GenericPagination = dependencies.GenericPagination

local function formatMessage(p1, p2) -- line: 16
	return table.concat(p1, "\n"):format(unpack(p2 or {}))
end
local function connect(p3) -- line: 20
	-- upvalues: Roact (copy), GenericPagination (copy), fetchInitSymbol (copy), fetchWithCursorSymbol (copy), Cryo (copy), loadNextSymbol (copy), Logger (copy), loadPreviousSymbol (copy)
	assert(p3 and type(p3) == "function", "RoactPaginator.connect: parameters expected to be a function")

	local trace = debug.traceback()

	return function(p4) -- line: 24
		-- upvalues: trace (copy), Roact (copy), p3 (copy), GenericPagination (copy), fetchInitSymbol (copy), fetchWithCursorSymbol (copy), Cryo (copy), loadNextSymbol (copy), Logger (copy), loadPreviousSymbol (copy)
		if p4 == nil then
			local t1 = { trace }
			local v19 = table.concat({
				"connect returns a function that must be passed a component.",
				"Check the connection at:",
				"%s"
			}, "\n"):format(unpack(t1 or {}))

			error(v19, 2)
		end

		local v20 = ("PaginatorConnection(%s)"):format((tostring(p4)))
		local v21 = Roact.Component:extend(v20)

		function v21.init(p5) -- line: 41
			-- upvalues: p3 (copy), GenericPagination (copy), fetchInitSymbol (copy), fetchWithCursorSymbol (copy)
			local v23 = p3()

			assert(v23, "RoactPaginator.connect: Expected parameters to return an object")
			p5.paginator = GenericPagination.new({
				pageSize = v23.pageSize,
				fetchInit = p5.props[fetchInitSymbol],
				fetchWithCursor = p5.props[fetchWithCursorSymbol]
			})
		end
		function v21.render(p6) -- line: 52
			-- upvalues: Cryo (copy), loadNextSymbol (copy), Logger (copy), loadPreviousSymbol (copy), Roact (copy), p4 (copy)
			local v25 = Cryo.Dictionary.join(p6.props, {
				[loadNextSymbol] = function() -- line: 54
					-- upvalues: p6 (copy), Logger (copy)
					if p6.paginator:isFetching() then
						return
					end

					p6.paginator:getNext():catch(function(p7) -- line: 59
						-- upvalues: Logger (copy)
						Logger:error("Could not getNext. Got error: {}", p7)
					end)
				end,
				[loadPreviousSymbol] = function() -- line: 63
					-- upvalues: p6 (copy), Logger (copy)
					if p6.paginator:isFetching() then
						return
					end

					p6.paginator:getPrevious():catch(function(p8) -- line: 68
						-- upvalues: Logger (copy)
						Logger:error("Could not getPrevious. Got error: {}", p8)
					end)
				end
			})

			return Roact.createElement(p4, v25)
		end

		return v21
	end
end

return connect
