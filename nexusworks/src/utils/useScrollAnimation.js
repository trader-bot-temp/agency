import { useEffect, useRef, useState } from 'react';

/**
 * useScrollAnimation
 * Returns a ref and a boolean that flips to true the first time the
 * element enters the viewport. Pairs with the `.reveal` CSS class.
 *
 * @param {object} options
 * @param {number} options.threshold  0–1, how much must be visible (default 0.15)
 * @param {string} options.rootMargin margin around the root (default '0px 0px -10% 0px')
 * @param {boolean} options.once       stop observing after first reveal (default true)
 */
export default function useScrollAnimation({
  threshold = 0.15,
  rootMargin = '0px 0px -10% 0px',
  once = true,
} = {}) {
  const ref = useRef(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const el = ref.current;
    if (!el) return undefined;

    // Respect reduced-motion: reveal immediately, skip observing.
    const prefersReduced = window.matchMedia(
      '(prefers-reduced-motion: reduce)'
    ).matches;
    if (prefersReduced) {
      setIsVisible(true);
      return undefined;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsVisible(true);
            if (once) observer.unobserve(entry.target);
          } else if (!once) {
            setIsVisible(false);
          }
        });
      },
      { threshold, rootMargin }
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, [threshold, rootMargin, once]);

  return [ref, isVisible];
}
