local W = display.contentWidth
local H = display.contentHeight

return {
	blocks = {
		{type="neutral", 			x=W*1.5, 		y=H*(0.8275), 		w=(W*3.5), 		h=H*.6},
		{type="neutral", 			x=W*1.9, 		y=H*(0.4775), 		w=(W*.1), 		h=H*.1},
		{type="neutral", 			x=W*3.05, 		y=H*(0.425), 		w=(W*.4), 		h=H*.25},
		{type="neutral", 			x=W*3.6, 		y=H*(0.125), 		w=(W*.2), 		h=H*.05},
		{type="neutral", 			x=W*3.9, 		y=H*(0.125), 		w=(W*.2), 		h=H*.05},
		{type="neutral", 			x=W*5.55, 		y=H*(1.275), 		w=(W*2.6), 		h=H*1.5},
		{type="light", 				x=W*4.675, 		y=H*(0.175), 		w=(W*.05), 		h=H*1},
		{type="dark", 				x=W*5.275, 		y=H*(0.175), 		w=(W*.05), 		h=H*1},
		{type="dark", 				x=W*7.15, 		y=H*(0.25), 		w=(W*.2), 		h=H*.05},
		{type="light", 				x=W*7.65, 		y=H*(0.10), 		w=(W*.2), 		h=H*.05},
		{type="dark", 				x=W*8.15, 		y=H*(-0.05), 		w=(W*.2), 		h=H*.05},
		{type="neutral", 			x=W*14.58, 		y=H*(-0.15), 		w=(W*12), 		h=H*.3},
		{type="neutral", 			x=W*9.7, 		y=H*(-.4), 			w=(W*.15), 		h=H*.2},
		{type="neutral", 			x=W*10.4, 		y=H*(-.4), 			w=(W*.15), 		h=H*.2},
		{type="neutral", 			x=W*11.8, 		y=H*(-.5), 			w=(W*.15), 		h=H*.4},
		{type="neutral", 			x=W*12.5, 		y=H*(-.4), 			w=(W*.15), 		h=H*.2},
		{type="fatal", 				x=W*15, 		y=H*(1.15), 		w=(W*30), 		h=H*.3},
		{type="neutral", 			x=W*15, 		y=H*(-1.4), 		w=(W*30), 		h=H*.3},
		{type="startZeroGravity", 	x=W*15.5, 		y=H*(-.35), 		w=(W*0.2), 		h=H*2},
		{type="neutral", 			x=W*16.5, 		y=H*(-.5), 			w=(W*.15), 		h=H*.4},
		{type="neutral", 			x=W*17, 		y=H*(-.65), 		w=(W*.15), 		h=H*.7},
		{type="endGame", 			x=W*19.58, 		y=H*(-.5), 			w=(W*.20), 		h=H*2},
	},

	spikes = {
		{x=W*5.875,			y=H*(0.525)-25},
		{x=W*5.875+64,		y=H*(0.525)-25},
		{x=W*14.6,			y=H*-.35},
	},

	coins = {
		{x=2.45*W,			y=0.4*H},
		{x=3.75*W,			y=-0.23*H},
		{x=4.975*W,			y=0.25*H},
		{x=5.875*W+32,		y=0.05*H},
		{x=7.35*W,			y=0.0*H},
		{x=12.15*W,			y=-1*H},
		{x=16.75*W,			y=-1.2*H},
	},

	powerUps = {
		{type=1,			x=9*W,				y=-0.42*H},
		{type=2,			x=11.1*W,			y=-0.42*H},
		{type=3,			x=13.2*W,			y=-0.42*H},
		{type=4,			x=13.9*W,			y=-0.42*H},
	},
}

