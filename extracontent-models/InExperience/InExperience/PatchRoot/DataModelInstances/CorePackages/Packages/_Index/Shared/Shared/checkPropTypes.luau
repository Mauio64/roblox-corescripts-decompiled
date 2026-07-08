local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Error = require(ParentParent.LuauPolyfill).Error
local console = require(script.Parent.console)
local t1 = {}
local describeUnknownElementTypeFrameInDEV = require(script.Parent.ReactComponentStackFrame).describeUnknownElementTypeFrameInDEV
local ReactSharedInternals = require(script.Parent.ReactSharedInternals)
local describeError = require(script.Parent["ErrorHandling.roblox"]).describeError
local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame

local function setCurrentlyValidatingElement(p1) -- line: 34
	-- upvalues: ReactGlobals (copy), describeUnknownElementTypeFrameInDEV (copy), ReactDebugCurrentFrame (copy)
	if ReactGlobals.__DEV__ then
		if p1 then
			local _owner = p1._owner
			local v14 = describeUnknownElementTypeFrameInDEV(p1.type, p1._source, if _owner == nil then nil else _owner.type)

			ReactDebugCurrentFrame.setExtraStackFrame(v14)

			return
		end

		ReactDebugCurrentFrame.setExtraStackFrame(nil)
	end
end
local function checkPropTypes(p2, p3: ((...any) -> ...any)?, p4, s1: string, s2: string?, p5) -- line: 51
	-- upvalues: ReactGlobals (copy), console (copy), Error (copy), describeError (copy), describeUnknownElementTypeFrameInDEV (copy), ReactDebugCurrentFrame (copy), t1 (copy)
	if ReactGlobals.__DEV__ or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		if p2 and p3 then
			console.warn("You've defined both propTypes and validateProps on " .. (s2 or "a component"))
		end

		if p3 then
			if typeof(p3) ~= "function" then
				console.error(("validateProps must be a function, but it is a %s.\nCheck the definition of the component %q."):format(typeof(p3), s2 or ""))
			else
				local v21, v22 = p3(p4)

				if not v21 then
					local v23 = v22 or "<Validator function did not supply a message>"
					local v24 = string.format("validateProps failed on a %s type in %s: %s", s1, s2 or "<UNKNOWN Component>", (tostring(v23)))

					error(v24)
				end
			end
		end

		if p2 then
			assert(typeof(p2) == "table", "propTypes needs to be a table")

			for v25, _ in p2 do
				local _, result = xpcall(function() -- line: 118
					-- upvalues: p2 (copy), v25 (copy), Error (copy), s2 (copy), s1 (copy), p4 (copy)
					if typeof(p2[v25]) ~= "function" then
						local v34 = Error.new((s2 or "React class") .. ": " .. s1 .. " type `" .. v25 .. "` is invalid; " .. "it must be a function, usually from the `prop-types` package, but received `" .. typeof(p2[v25]) .. "`." .. "This often happens because of typos such as `PropTypes.function` instead of `PropTypes.func`.")

						v34.name = "Invariant Violation"
						error(v34)
					end

					return p2[v25](p4, v25, s2, s1, nil, "SECRET_DO_NOT_PASS_THIS_OR_YOU_WILL_BE_FIRED")
				end, describeError)
				local v29 = typeof(result) == "table"

				if result ~= nil and not v29 then
					if ReactGlobals.__DEV__ then
						if p5 then
							local _owner = p5._owner
							local v31 = describeUnknownElementTypeFrameInDEV(p5.type, p5._source, if _owner == nil then nil else _owner.type)

							ReactDebugCurrentFrame.setExtraStackFrame(v31)
						else
							ReactDebugCurrentFrame.setExtraStackFrame(nil)
						end
					end

					console.error(string.format("%s: type specification of %s `%s` is invalid; the type checker function must return `nil` or an `Error` but returned a %s. You may have forgotten to pass an argument to the type checker creator (arrayOf, instanceOf, objectOf, oneOf, oneOfType, and shape all require an argument).", s2 or "React class", s1, v25, (typeof(result))))

					if ReactGlobals.__DEV__ then
						ReactDebugCurrentFrame.setExtraStackFrame(nil)
					end
				end

				if v29 and t1[result.message] == nil then
					t1[tostring(result.message)] = true

					if ReactGlobals.__DEV__ then
						if p5 then
							local _owner = p5._owner
							local v33 = describeUnknownElementTypeFrameInDEV(p5.type, p5._source, if _owner == nil then nil else _owner.type)

							ReactDebugCurrentFrame.setExtraStackFrame(v33)
						else
							ReactDebugCurrentFrame.setExtraStackFrame(nil)
						end
					end

					console.warn(string.format("Failed %s type: %s", s1, (tostring(result.message))))

					if ReactGlobals.__DEV__ then
						ReactDebugCurrentFrame.setExtraStackFrame(nil)
					end
				end
			end
		end
	end
end

return checkPropTypes
