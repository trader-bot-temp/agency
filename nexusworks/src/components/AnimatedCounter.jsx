import CountUp from 'react-countup';
import useScrollAnimation from '../utils/useScrollAnimation';

/**
 * AnimatedCounter
 * Counts up to `end` when scrolled into view. Supports prefix/suffix and
 * decimals. Respects reduced-motion (the hook reveals instantly there,
 * and CountUp's duration becomes negligible).
 *
 * @param {number} end       target value
 * @param {string} prefix    text before the number (e.g. "$")
 * @param {string} suffix    text after the number (e.g. "+", "%", "x")
 * @param {number} decimals  decimal places (default 0)
 * @param {number} duration  seconds (default 2)
 */
export default function AnimatedCounter({
  end,
  prefix = '',
  suffix = '',
  decimals = 0,
  duration = 2,
  className = '',
}) {
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.4 });

  return (
    <span ref={ref} className={className}>
      {isVisible ? (
        <CountUp
          end={end}
          duration={duration}
          decimals={decimals}
          prefix={prefix}
          suffix={suffix}
          separator=","
        />
      ) : (
        <span>
          {prefix}0{suffix}
        </span>
      )}
    </span>
  );
}
