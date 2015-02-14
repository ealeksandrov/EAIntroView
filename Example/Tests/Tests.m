//
//  Tests.m
//
//  Copyright (c) 2015 Evgeny Aleksandrov. License: MIT.

SpecBegin(InitialSpecs)

describe(@"these will fail", ^{
    
    it(@"can do maths", ^{
        expect(1).to.equal(2);
    });
    
    it(@"can read", ^{
        expect(@"number").to.equal(@"string");
    });
});

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
});

SpecEnd
