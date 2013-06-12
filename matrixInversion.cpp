void invert( double ** const A, double ** const B, int n ) {
	for ( int i = 0; i < n; i++ ) {
		for ( int j = 0; j < i; j++ ) B[ i ][ j ] = 0;
		B[ i ][ i ] = 1;
		for ( int j = i + 1; j < n; j++ ) B[ i ][ j ] = 0;
	}
	for ( int k = 0; k < n; k++ ) {
		double temp = A[ k ][ k ];
		for ( int j = k; j < n; j++ ) A[ k ][ j ] /= temp;
		for ( int j = 0; j <= k; j++ ) B[ k ][ j ] /= temp;
		
		for ( int i = 0; i < n; i++ ) {
			if ( i == k ) continue;
			
			temp = -A[ i ][ k ];
			for ( int j = k; j < n; j++ ) A[ i ][ j ] += A[ k ][ j ] * temp;
			for ( int j = 0; j <= k; j++ ) B[ i ][ j ] += B[ k ][ j ] * temp;
		}
	}
}