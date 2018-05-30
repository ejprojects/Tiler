// ********************************************************************************************************************
// tile symmetries

// float[][] symmetry = {	{0,		0,		PI,		PI	},		// rotation
// 						{0,		PI,		0,		PI	},		// flip, i.e., rotation on y axis
// 						{0,		0,		0,		0,	},		// x translation
// 						{0,		0,		0,		0,	}	};	// y translation

// float[][] symmetry = {	{0,		0,		2*PI/3,	2*PI/3,	4*PI/3,	4*PI/3	},		// rotation
// 						{0,		PI,		0,		PI,		0,		PI		},		// flip, 180 for mirror
// 						{0,		0,		0,		0,		0,		0		},		// x translation
// 						{0,		0,		0,		0,		0,		0		}	};	// y translation


float[][] symmetry = {
// 12 hexagon-mirror
//0		1		2		3		4		5		6		7		8		9		10		11			*/
{0,		PI/3,	2*PI/3,	PI,		4*PI/3,	5*PI/3,	TWO_PI, 7*PI/3,	8*PI/3,	9*PI/3,	10*PI/3,11*PI/3},	// rotation
{0,		0.1,	0.2,	0.3,	0.4,	0.5,	0.6,	0.7,	0.8,	0.9,	1.0,	1.1},		// flip, PI for mirror
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// x translation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0}			// y translation
};

