import * as Lucide from 'lucide-react';

/**
 * Icon
 * Resolves a Lucide icon by its component name (string) so data files
 * can reference icons declaratively. Falls back to a neutral dot.
 *
 * @param {string} name  Lucide component name, e.g. "Megaphone"
 */
export default function Icon({ name, size = 22, strokeWidth = 1.8, ...rest }) {
  const Cmp = Lucide[name] || Lucide.Circle;
  return <Cmp size={size} strokeWidth={strokeWidth} aria-hidden="true" {...rest} />;
}
