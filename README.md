B - test
=========

Syntax
------

	[h, p] = btest(X, Y)
	[h, p] = btest(X, Y, kernel)

Description
-----------

B-test is a fast maximum mean discrepancy (MMD) kernel two-sample tests that has low sample complexity and is consistent. The B-test uses a smaller than quadratic number of kernel evaluations and avoids completely the computational burden of complex null-hypothesis approximation, while maintaining consistency and probabilistically conservative thresholds on Type I error.

	[h, p] = btest(____)

Returns a test decision for the null hypothesis that the data X comes from the same distribution as the data Y. By default B-test computes RBF-kernel for input data points X and Y. However, any kernel might be provided. p corresponds to p-value of the test.

More on it under [url] [1].

[1]: http://www.cs.nyu.edu/~zaremba/docs/btest.pdf        "url"
