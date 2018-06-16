// ********************************************************************************************************************
// tile symmetries

// symmetry variables describe symmetry within repeatable clusters that will tile the plane
// tiling variables describe the transformations necessary when tilin gout the clusters



float[][] symmetry1 = {	{0},		// rotation
						{0},		// flip, i.e., rotation on y axis
						{0},		// x translation
						{0}	};		// y translation

float[][] symmetry4 = {	{0,		0,		PI,		PI	},		// rotation
						{0,		PI,		0,		PI	},		// flip, i.e., rotation on y axis
						{0,		0,		0,		0,	},		// x translation
						{0,		0,		0,		0,	}	};	// y translation

float[][] symmetry6 =  {	{0,		1*PI/3,	2*PI/3,	3*PI/3,	4*PI/3,	5*PI/3	},		// rotation
							{0,		0,		0,		0,		0,		0		},		// flip, 180 for mirror
							{0,		0,		0,		0,		0,		0		},		// x translation
							{0,		0,		0,		0,		0,		0		}	};	// y translation

float[][] symmetry6M = {	{0,		0,		2*PI/3,	2*PI/3,	4*PI/3,	4*PI/3	},		// rotation
							{0,		PI,		0,		PI,		0,		PI		},		// flip, 180 for mirror
							{0,		0,		0,		0,		0,		0		},		// x translation
							{0,		0,		0,		0,		0,		0		}	};	// y translation


float[][] symmetry12M = {
//0		1		2		3		4		5		6		7		8		9		10		11			*/
{0,		0,		2*PI/6,	2*PI/6,	4*PI/6,	4*PI/6,	6*PI/6, 6*PI/6,	8*PI/6,	8*PI/6,	10*PI/6,10*PI/6},	// rotation
{0,		PI,		0,		PI,		0,		PI,		0,		PI,		0,		PI,		0,		PI},		// flip, PI for mirror
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// x translation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0}			// y translation
};

float[][] tiling12M = {	{	692.6,	1.5,	0.75,	2,	57.667	},		// clusterWidth, hStep, hOffset, hOffestPeriod, tileCenterX
						{	600,	0.5,	0,		1,	200		} };	// clusterHeight, vStep, vOffset, vOffestPeriod, tileCenterY

float[][] symmetry12 = {
//0		1		2		3		4		5		6		7		8		9		10		11			*/
{0*PI/6,1*PI/6,	2*PI/6,	3*PI/6,	4*PI/6,	5*PI/6,	6*PI/6, 7*PI/6,	8*PI/6,	9*PI/6,	10*PI/6,11*PI/6},	// rotation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// flip, PI for mirror
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// x translation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0}			// y translation
};