SignalQueue = {}

function QueueSignal(...)
	SignalQueue[#SignalQueue+1] = {...}
end

function PullSignal()
	return table.remove(SignalQueue,1) -- i love you, lua
end