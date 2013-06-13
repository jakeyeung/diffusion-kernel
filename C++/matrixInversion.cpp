#include <cmath>
#define EPS 1e-10

bool invertInPlace( double ** const A, int n ) {
	for ( int k = 0; k < n; k++ ) {
		if ( fabs( A[ k ][ k ] ) < EPS ) return 0;
		
		double temp = A[ k ][ k ];
		A[ k ][ k ] = 1;
		for ( int j = 0; j < n; j++ ) A[ k ][ j ] /= temp;
		
		for ( int i = 0; i < n; i++ ) {
			if ( i == k ) continue;
			
			temp = -A[ i ][ k ];
			A[ i ][ k ] = 0;
			for ( int j = 0; j < n; j++ ) A[ i ][ j ] += A[ k ][ j ] * temp;
		}
	}
	
	return 1;
}