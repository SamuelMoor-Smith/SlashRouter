// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/base/Staking20Base.sol";

contract Staking1 is Staking20Base {
    constructor(
        address _defaultAdmin,
        uint256 _timeUnit,
        uint256 _rewardRatioNumerator,
        uint256 _rewardRatioDenominator,
        address _stakingToken,
        address _rewardToken,
        address _nativeTokenWrapper
    )
        Staking20Base(
            _defaultAdmin,
            _timeUnit,
            _rewardRatioNumerator,
            _rewardRatioDenominator,
            _stakingToken,
            _rewardToken,
            _nativeTokenWrapper
        )
    {}

    function slash(address _account, uint256 _amount) external {
        require(_canSlash(), "Caller is not owner and therefore cannot slash");

        // How much stake does the account have?
        uint256 amountAvailableToSlash = stakers[_account].amountStaked;

        // require the amount to slash is less than or equal to the amount available to stake
        require(_amount <= amountAvailableToSlash, "Cannot slash more than the amount available to stake");

        // Slash the stake
        stakers[_account].amountStaked -= _amount;
        stakingTokenBalance -= _amount;
    }

    /// @dev Returns whether owner can be set in the given execution context.
    function _canSlash() internal view virtual returns (bool) {
        return msg.sender == owner();
    }
}