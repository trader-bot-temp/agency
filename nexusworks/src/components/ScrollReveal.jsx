import useScrollAnimation from '../utils/useScrollAnimation';

/**
 * ScrollReveal
 * Wraps children in an element that fades/slides up when scrolled into view.
 * Uses the `.reveal` CSS class + `is-visible` toggle.
 *
 * @param {1|2|3|4} delay   stagger step (maps to CSS data-delay)
 * @param {string}  as      element tag to render (default "div")
 */
export default function ScrollReveal({
  children,
  delay,
  as: Tag = 'div',
  className = '',
  ...rest
}) {
  const [ref, isVisible] = useScrollAnimation();

  return (
    <Tag
      ref={ref}
      className={`reveal ${isVisible ? 'is-visible' : ''} ${className}`.trim()}
      data-delay={delay}
      {...rest}
    >
      {children}
    </Tag>
  );
}
