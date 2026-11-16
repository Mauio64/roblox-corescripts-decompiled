local parent = script.Parent.Parent

local React = require(parent.React)
require(script.Parent.Message)

local context = React.createContext(nil)
local MessageWriterContext = {}
MessageWriterContext.Context = context

function MessageWriterContext.Provider(props)
	local v = React.useMemo(function()
		return { write = props.upsertMessage, remove = props.removeMessage }
	end, { props.upsertMessage, props.removeMessage })

	return React.createElement(context.Provider, { value = v }, props.children)
end

function MessageWriterContext.useMessageWriter()
	return React.useContext(context)
end

return MessageWriterContext
