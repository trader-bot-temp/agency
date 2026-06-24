import { motion, useScroll, useSpring } from 'framer-motion';

/**
 * ScrollProgress
 * A thin violet line at the top of the viewport that fills with page
 * scroll. Uses Framer Motion's scroll progress + a spring for smoothness.
 */
export default function ScrollProgress() {
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, {
    stiffness: 120,
    damping: 30,
    restDelta: 0.001,
  });

  return <motion.div className="scroll-progress" style={{ scaleX }} aria-hidden="true" />;
}
