local members={
	'update','render',
	'keyPressed','keyReleased',
	'mousePressed','mouseMoved','mouseReleased','wheelMoved',
	'enter','exit'
}

function State()
	local class=Class()
	for i=1,#members do
		class[members[i]]=function() end
	end
	return class
end
