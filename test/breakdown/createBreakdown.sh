#!/bin/bash

# All tests
echo "Processing all tests..."
find ../. -type f -name "*.js" > allTests.tests
grep -rlZ 'noStrict' ../. --include='*.js' > allNoStrict.tests
grep -rlZ 'onlyStrict' ../. --include='*.js' > allOnlyStrict.tests
comm -23 <(sort allTests.tests) <(sort allNoStrict.tests) > allBothModes.tests
comm -23 <(sort allBothModes.tests) <(sort allOnlyStrict.tests) > allBothModesTemp.tests
mv allBothModesTemp.tests allBothModes.tests

# Negative tests
echo "Processing negative tests..."
grep -rlZ 'negative:' ../. --include='*.js' > allNegativeTests.tests
grep -rlZ 'noStrict' ../. | xargs grep -lZe 'negative:' --include='*.js' > negativeNoStrict.tests
grep -rlZ 'onlyStrict' ../. | xargs grep -lZe 'negative:' --include='*.js' > negativeOnlyStrict.tests
comm -23 <(sort allNegativeTests.tests) <(sort negativeNoStrict.tests) > negativeBothModes.tests
comm -23 <(sort negativeBothModes.tests) <(sort negativeOnlyStrict.tests) > negativeBothModesTemp.tests
mv negativeBothModesTemp.tests negativeBothModes.tests

# Positive tests
echo "Processing positive tests..."
comm -23 <(sort allTests.tests) <(sort allNegativeTests.tests) > allPositiveTests.tests
xargs grep -lZe 'noStrict' --include='*.js' <allPositiveTests.tests > positiveNoStrict.tests
xargs grep -lZe 'onlyStrict' --include='*.js' <allPositiveTests.tests > positiveOnlyStrict.tests
comm -23 <(sort allPositiveTests.tests) <(sort positiveNoStrict.tests) > positiveBothModes.tests
comm -23 <(sort positiveBothModes.tests) <(sort positiveOnlyStrict.tests) > positiveBothModesTemp.tests
mv positiveBothModesTemp.tests positiveBothModes.tests

# Remove the leading path
find . -maxdepth 1 -type f -name '*.tests' -exec sed -i '' s/\.\.\\\/\./test/ {} +